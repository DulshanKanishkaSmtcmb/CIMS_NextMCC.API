using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.MasterData.PmSupplier;
using CIMSNextMCC.Domain.Entities.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.MasterData;

public class PmSupplierHandlerTests
{
    private static PmSupplierMaster Row(string code, string name) => new() { PmSupplierCode = code, PmSupplierName = name, CountryCode = "LKA" };

    private static SavePmSupplierDataHandler SaveHandler(FakePmSupplierRepository repository) =>
        new(repository, new SavePmSupplierDataValidator());

    private static SavePmSupplierDataCommand New(string name) =>
        new(SaveMode.New, "", name, "A1", "A2", "A3", "A4", "C1", "C2", "C3", "T", "e@x", "F", "LKA");

    private static SavePmSupplierDataCommand Change(string code, string name) =>
        new(SaveMode.Change, code, name, "A1", "A2", "A3", "A4", "C1", "C2", "C3", "T", "e@x", "F", "LKA");

    [Fact]
    public async Task List_maps_every_column_in_repository_order()
    {
        var repository = new FakePmSupplierRepository
        {
            Rows =
            [
                new PmSupplierMaster
                {
                    PmSupplierCode = "A0001", PmSupplierName = "ALPHA", PmSupplierAddress1 = "a1", PmSupplierContact2 = "c2", PmSupplierTel = "t",
                    PmSupplierEmail = "m", PmSupplierFax = "f", CountryCode = "LKA",
                },
                Row("B0001", "BETA"),
            ],
        };

        var result = await new GetPmSupplierListHandler(repository).HandleAsync(new GetPmSupplierListQuery());

        Assert.Equal(["A0001", "B0001"], result.Data!.Select(d => d.PmSupplierCode));
        Assert.Equal(new PmSupplierDto("A0001", "ALPHA", "a1", "", "", "", "", "c2", "", "t", "m", "f", "LKA"), result.Data![0]);
    }

    [Fact]
    public async Task Data_returns_the_row_or_the_not_found_code_and_checks_the_length()
    {
        var handler = new GetPmSupplierDataHandler(new FakePmSupplierRepository { Rows = [Row("A0001", "ALPHA")] }, new GetPmSupplierDataValidator());

        var found = await handler.HandleAsync(new GetPmSupplierDataQuery("a0001"));
        var missing = await handler.HandleAsync(new GetPmSupplierDataQuery("Q9999"));

        Assert.Equal("ALPHA", found.Data!.PmSupplierName);
        Assert.Equal("PM_SUPPLIER_NOT_FOUND", missing.MessageCode);
        await Assert.ThrowsAsync<ValidationException>(() => handler.HandleAsync(new GetPmSupplierDataQuery("A00012")));
    }

    [Fact]
    public async Task New_generates_the_next_code_for_the_first_character_and_calls_PMSupplierAdd()
    {
        var repository = new FakePmSupplierRepository { Codes = ["M0001", "M0004", "T0002"] };

        var result = await SaveHandler(repository).HandleAsync(New("Maxim Two"));

        Assert.Equal(new SavePmSupplierResultDto("M0005", "Data Saved Successfully"), result.Data);
        Assert.Equal(["GetLastCode(M)", "PMSupplierAdd(M0005,Maxim Two)"], repository.Calls);
        var write = repository.Writes.Single();
        Assert.Equal(("A1", "A4", "C3", "T", "e@x", "F", "LKA"),
            (write.PmSupplierAddress1, write.PmSupplierAddress4, write.PmSupplierContact3, write.PmSupplierTel, write.PmSupplierEmail,
                write.PmSupplierFax, write.CountryCode));
    }

    [Fact]
    public async Task New_starts_a_letter_at_0001_and_refuses_a_full_series()
    {
        var first = await SaveHandler(new FakePmSupplierRepository { Codes = ["A0001"] }).HandleAsync(New("Zeta"));
        var full = await Assert.ThrowsAsync<AppException>(() =>
            SaveHandler(new FakePmSupplierRepository { Codes = ["Z9999"] }).HandleAsync(New("Zulu")));

        Assert.Equal("Z0001", first.Data!.PmSupplierCode);
        Assert.Equal(409, full.StatusCode);
    }

    [Fact]
    public async Task Change_calls_PMSupplierEdit_and_may_rename_without_the_starting_letter_rule()
    {
        var repository = new FakePmSupplierRepository { Rows = [Row("F0001", "Fine Line")] };

        var result = await SaveHandler(repository).HandleAsync(Change("F0001", "Zine Line"));

        Assert.True(result.IsSuccess);
        Assert.Equal(["PMSupplierEdit(F0001,Zine Line)"], repository.Calls);
    }

    [Fact]
    public async Task Change_of_an_unknown_code_is_a_404_and_writes_nothing()
    {
        var repository = new FakePmSupplierRepository();

        var ex = await Assert.ThrowsAsync<NotFoundException>(() => SaveHandler(repository).HandleAsync(Change("F0001", "Fine")));

        Assert.Equal("PM_SUPPLIER_CODE_NOT_FOUND", ex.MessageCode);
        Assert.Empty(repository.Calls);
    }

    [Fact]
    public async Task Validation_has_the_one_legacy_message_for_a_missing_name_and_the_code_message_only_for_Change()
    {
        var newEmpty = await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(new FakePmSupplierRepository()).HandleAsync(New("")));
        var changeEmpty = await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(new FakePmSupplierRepository()).HandleAsync(Change("", "")));

        Assert.Equal(["Enter Supplier Name"], newEmpty.Errors.Select(e => e.ErrorMessage));
        Assert.Equal(["Enter Supplier Name", "Enter Supplier Code"], changeEmpty.Errors.Select(e => e.ErrorMessage));
    }

    [Theory]
    [InlineData("name", 51)]
    [InlineData("tel", 51)]
    [InlineData("country", 11)]
    public async Task Validation_rejects_values_longer_than_the_stored_procedure_parameters(string field, int length)
    {
        var text = new string('x', length);
        var command = New("Sam") with
        {
            PmSupplierName = field == "name" ? "S" + text : "Sam",
            PmSupplierTel = field == "tel" ? text : "",
            CountryCode = field == "country" ? text : "LKA",
        };

        await Assert.ThrowsAsync<ValidationException>(() => SaveHandler(new FakePmSupplierRepository()).HandleAsync(command));
    }
}
