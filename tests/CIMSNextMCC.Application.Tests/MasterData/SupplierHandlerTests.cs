using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.Supplier;
using CIMSNextMCC.Domain.Entities.MasterData;
using CIMSNextMCC.Domain.Entities.Security;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

public class SupplierHandlerTests
{
    private static SupplierMaster Row(string code, string name) =>
        new() { ShipperCode = code, ShipperName = name, CreateBy = "e", UpdateBy = "", CountryCode = "IND" };

    private static SaveSupplierDataHandler SaveHandler(FakeSupplierRepository repository, params LegacyUser[] users) =>
        new(repository, AuditUser.Resolver(users), new SaveSupplierDataValidator());

    private static SaveSupplierDataCommand New(string name, string country = "IND") =>
        new(SaveMode.New, "", name, "A1", "A2", "A3", "A4", "C1", "C2", "C3", "T", "e@x", "F", country, "AF", "SF", "LM", "RX");

    private static SaveSupplierDataCommand Change(string code, string name) =>
        new(SaveMode.Change, code, name, "A1", "A2", "A3", "A4", "C1", "C2", "C3", "T", "e@x", "F", "IND", "AF", "SF", "LM", "RX");

    [Fact]
    public async Task List_maps_every_column_in_repository_order()
    {
        var created = new DateTime(2026, 8, 21, 9, 38, 42);
        var repository = new FakeSupplierRepository
        {
            Rows =
            [
                new SupplierMaster
                {
                    ShipperCode = "A0001", ShipperName = "ALPHA", ShipperAddress1 = "a1", ShipperContact3 = "c3", DateCreate = created, CreateBy = "x",
                    ShipperCodeAir = "AF", ShipperCodeSea = "SF", ShipperTel = "t", ShipperEmail = "m", ShipperFax = "f", CountryCode = "IND",
                    LimaSupplierCode = "LM", RexNo = "RX",
                },
                Row("B0001", "BETA"),
            ],
        };

        var result = await new GetSupplierListHandler(repository).HandleAsync(new GetSupplierListQuery());

        Assert.Equal(["A0001", "B0001"], result.Data!.Select(d => d.ShipperCode));
        var first = result.Data![0];
        Assert.Equal(("ALPHA", "a1", "c3", created, "x", "AF", "SF", "t", "m", "f", "IND", "LM", "RX"),
            (first.ShipperName, first.ShipperAddress1, first.ShipperContact3, first.DateCreate, first.CreateBy, first.ShipperCodeAir,
                first.ShipperCodeSea, first.ShipperTel, first.ShipperEmail, first.ShipperFax, first.CountryCode, first.LimaSupplierCode, first.RexNo));
    }

    [Fact]
    public async Task Data_returns_the_row_or_the_not_found_code()
    {
        var handler = new GetSupplierDataHandler(new FakeSupplierRepository { Rows = [Row("A0001", "ALPHA")] }, new GetSupplierDataValidator());

        var found = await handler.HandleAsync(new GetSupplierDataQuery("a0001"));
        var missing = await handler.HandleAsync(new GetSupplierDataQuery("Q9999"));

        Assert.Equal("ALPHA", found.Data!.ShipperName);
        Assert.False(missing.IsSuccess);
        Assert.Equal("SUPPLIER_NOT_FOUND", missing.MessageCode);
    }

    [Fact]
    public async Task Data_rejects_a_code_longer_than_the_column()
    {
        var handler = new GetSupplierDataHandler(new FakeSupplierRepository(), new GetSupplierDataValidator());

        await Assert.ThrowsAsync<ValidationException>(() => handler.HandleAsync(new GetSupplierDataQuery("A00012")));
    }

    [Fact]
    public async Task Search_passes_the_typed_text_and_mode_and_maps_the_hits()
    {
        var repository = new FakeSupplierRepository
        {
            Hits = [new SupplierNameHit { ShipperCode = "S0001", ShipperName = "SAM", ShipperAddress1 = "x", ShipperAddress4 = "y" }],
        };
        var handler = new FindSupplierNameHandler(repository, new FindSupplierNameValidator());

        var result = await handler.HandleAsync(new FindSupplierNameQuery("S", StartsWith: true));

        Assert.Equal(("S", true), repository.LastSearch);
        Assert.Equal([new SupplierNameHitDto("S0001", "SAM", "x", "", "", "y")], result.Data);
    }

    [Fact]
    public async Task Air_and_sea_lists_and_data_map_the_rows_and_report_unknown_codes()
    {
        var repository = new FakeFreightShipperRepository
        {
            Air = [new FreightShipper { ShCode = "A1", ShName = "AIR ONE", ShAdd1 = "x" }],
            Sea = [new FreightShipper { ShCode = "S1", ShName = "SEA ONE", ShAdd4 = "z" }],
        };

        var air = await new GetAirShipperListHandler(repository).HandleAsync(new GetAirShipperListQuery());
        var sea = await new GetSeaShipperListHandler(repository).HandleAsync(new GetSeaShipperListQuery());
        var airOne = await new GetAirShipperDataHandler(repository, new GetAirShipperDataValidator()).HandleAsync(new GetAirShipperDataQuery("A1"));
        var seaMissing = await new GetSeaShipperDataHandler(repository, new GetSeaShipperDataValidator()).HandleAsync(new GetSeaShipperDataQuery("S9"));

        Assert.Equal([new FreightShipperDto("A1", "AIR ONE", "x", "", "", "")], air.Data);
        Assert.Equal([new FreightShipperDto("S1", "SEA ONE", "", "", "", "z")], sea.Data);
        Assert.Equal(new FreightShipperNameDto("A1", "AIR ONE"), airOne.Data);
        Assert.Equal("SEA_SHIPPER_NOT_FOUND", seaMissing.MessageCode);
    }

    [Fact]
    public async Task An_unreachable_air_or_sea_database_is_a_503_not_an_empty_list()
    {
        var repository = new FakeFreightShipperRepository { Unavailable = true };

        var ex = await Assert.ThrowsAsync<AppException>(() => new GetAirShipperListHandler(repository).HandleAsync(new GetAirShipperListQuery()));

        Assert.Equal(503, ex.StatusCode);
    }

    [Fact]
    public async Task Shipper_data_rejects_a_code_longer_than_5()
    {
        var handler = new GetSeaShipperDataHandler(new FakeFreightShipperRepository(), new GetSeaShipperDataValidator());

        await Assert.ThrowsAsync<ValidationException>(() => handler.HandleAsync(new GetSeaShipperDataQuery("ABCDEF")));
    }

    [Fact]
    public async Task New_generates_the_next_code_for_the_first_character_and_calls_ShipperAdd_with_the_PwInfo_UserId()
    {
        var repository = new FakeSupplierRepository { Codes = ["S0040", "S0041", "A0027"] };

        var result = await SaveHandler(repository, new LegacyUser { UserName = "floor1", UserId = "`djdXYZ" }).HandleAsync(New("Samsung"));

        Assert.Equal(new SaveSupplierResultDto("S0042", "Data Saved Successfully"), result.Data);
        Assert.Equal(["GetLastCode(S)", "ShipperAdd(S0042,Samsung,`djdXYZ)"], repository.Calls);
        var write = repository.Writes.Single();
        Assert.Equal(("A1", "A2", "A3", "A4", "C1", "C2", "C3", "AF", "SF", "T", "e@x", "F", "IND", "LM", "RX"),
            (write.ShipperAddress1, write.ShipperAddress2, write.ShipperAddress3, write.ShipperAddress4, write.ShipperContact1, write.ShipperContact2,
                write.ShipperContact3, write.ShipperCodeAir, write.ShipperCodeSea, write.ShipperTel, write.ShipperEmail, write.ShipperFax,
                write.CountryCode, write.LimaSupplierCode, write.RexNo));
    }

    [Fact]
    public async Task New_starts_a_letter_at_0001_and_keeps_the_typed_case_and_a_leading_space()
    {
        var repository = new FakeSupplierRepository { Codes = ["A0027"] };

        var first = await SaveHandler(repository).HandleAsync(New("Zeta"));
        var lower = await SaveHandler(repository).HandleAsync(New("alpha"));
        var spaced = await SaveHandler(new FakeSupplierRepository { Codes = [" 0001"] }).HandleAsync(New(" JEENA 2"));

        Assert.Equal("Z0001", first.Data!.SupplierCode);
        Assert.Equal("a0028", lower.Data!.SupplierCode);
        Assert.Equal(" 0002", spaced.Data!.SupplierCode);
    }

    [Theory]
    [InlineData("A0001", "A0002")]
    [InlineData("A0009", "A0010")]
    [InlineData("A0099", "A0100")]
    [InlineData("A9998", "A9999")]
    [InlineData("A27", "A0028")]
    public void Sequence_adds_one_to_the_last_number(string last, string expected)
    {
        Assert.Equal(expected, SupplierCodeSequence.Next(last[..1], last));
    }

    [Theory]
    [InlineData("A9999")]
    [InlineData("AXYZ1")]
    [InlineData("A")]
    [InlineData("A00001")]
    public void Sequence_refuses_a_full_or_unreadable_series_instead_of_wrapping_or_crashing(string last)
    {
        var ex = Assert.Throws<AppException>(() => SupplierCodeSequence.Next("A", last));

        Assert.Equal(409, ex.StatusCode);
        Assert.Equal("SUPPLIER_CODE_SEQUENCE_EXHAUSTED", ex.MessageCode);
    }

    [Fact]
    public async Task Change_calls_ShipperEdit_with_the_PwInfo_UserId_as_UpdateBy_and_saves_the_Lima_code_it_was_given()
    {
        var repository = new FakeSupplierRepository { Rows = [Row("S0001", "SAM")] };

        var result = await SaveHandler(repository).HandleAsync(Change("S0001", "Sam Two"));

        Assert.Equal(new SaveSupplierResultDto("S0001", "Data Saved Successfully"), result.Data);
        Assert.Equal(["ShipperEdit(S0001,Sam Two,U-0001)"], repository.Calls);
        Assert.Equal("LM", repository.Writes.Single().LimaSupplierCode);
    }

    [Fact]
    public async Task Change_of_an_unknown_code_is_a_404_and_writes_nothing()
    {
        var repository = new FakeSupplierRepository();

        var ex = await Assert.ThrowsAsync<NotFoundException>(() => SaveHandler(repository).HandleAsync(Change("S0001", "Sam")));

        Assert.Equal("SUPPLIER_CODE_NOT_FOUND", ex.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Change_requires_the_name_to_start_with_the_first_character_of_the_code()
    {
        var repository = new FakeSupplierRepository { Rows = [Row("S0001", "SAM")] };

        var ex = await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(repository).HandleAsync(Change("S0001", "Tam")));

        Assert.Equal(["Supplier Name should be Starting with S"], ex.Errors.Select(e => e.ErrorMessage));
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task The_starting_letter_rule_is_case_sensitive_like_the_legacy_browser_check()
    {
        var repository = new FakeSupplierRepository { Rows = [Row("S0001", "SAM")] };

        await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(repository).HandleAsync(Change("S0001", "sam")));
    }

    [Fact]
    public async Task Validation_reports_the_name_before_the_code_with_the_legacy_texts()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(new FakeSupplierRepository()).HandleAsync(Change("", "")));

        Assert.Equal(["Enter Supplier Name", "Enter Supplier Code"], ex.Errors.Select(e => e.ErrorMessage));
    }

    [Fact]
    public async Task New_needs_only_a_name()
    {
        var ex = await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(new FakeSupplierRepository()).HandleAsync(New("")));

        Assert.Equal(["Enter Supplier Name"], ex.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData("name", 51)]
    [InlineData("address", 51)]
    [InlineData("country", 11)]
    [InlineData("air", 6)]
    [InlineData("lima", 11)]
    public async Task Validation_rejects_values_longer_than_the_stored_procedure_parameters(string field, int length)
    {
        var text = new string('x', length);
        var command = New("Sam") with
        {
            ShipperName = field == "name" ? "S" + text : "Sam",
            ShipperAddress1 = field == "address" ? text : "",
            CountryCode = field == "country" ? text : "IND",
            ShipperCodeAir = field == "air" ? text : "",
            LimaSupplierCode = field == "lima" ? text : "",
        };

        await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(new FakeSupplierRepository()).HandleAsync(command));
    }

    [Fact]
    public async Task An_unknown_PwInfo_user_is_refused_before_anything_is_written()
    {
        var repository = new FakeSupplierRepository();
        var handler = new SaveSupplierDataHandler(
            repository,
            new CIMSNextMCC.Application.Common.Security.LegacyAuditUserResolver(
                new FakeLegacyUserRepositoryNone(), new CIMSNextMCC.Application.Tests.Arrivals.FakeCurrentUser("floor1")),
            new SaveSupplierDataValidator());

        var ex = await Assert.ThrowsAsync<ForbiddenException>(() => handler.HandleAsync(New("Sam")));

        Assert.Equal("LEGACY_USER_NOT_FOUND", ex.MessageCode);
        Assert.Empty(repository.Calls);
    }
}
