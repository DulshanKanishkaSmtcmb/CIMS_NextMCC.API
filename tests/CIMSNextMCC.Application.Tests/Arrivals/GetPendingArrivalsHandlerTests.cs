using CIMSNextMCC.Application.Arrivals.ConfirmArrival;
using CIMSNextMCC.Domain.Entities.Arrivals;
using CIMSNextMCC.Domain.Entities.Reference;
using FluentValidation;

namespace CIMSNextMCC.Application.Tests.Arrivals;

public class GetPendingArrivalsHandlerTests
{
    private static GetPendingArrivalsHandler Handler(FakeConfirmArrivalRepository repository) =>
        new(repository, new GetPendingArrivalsValidator());

    [Fact]
    public async Task All_and_empty_values_mean_no_filter_like_the_legacy_page()
    {
        var repository = new FakeConfirmArrivalRepository();

        await Handler(repository).HandleAsync(new GetPendingArrivalsQuery(CargoFrom: "", Dc: "All", Country: "All"));

        Assert.Equal(new PendingArrivalFilter(null, null, null), repository.LastFilter);
    }

    [Fact]
    public async Task Omitted_values_mean_no_filter()
    {
        var repository = new FakeConfirmArrivalRepository();

        await Handler(repository).HandleAsync(new GetPendingArrivalsQuery(null, null, null));

        Assert.Equal(new PendingArrivalFilter(null, null, null), repository.LastFilter);
    }

    [Fact]
    public async Task Other_values_are_exact_matches_including_an_empty_dc_or_country()
    {
        var repository = new FakeConfirmArrivalRepository();

        await Handler(repository).HandleAsync(new GetPendingArrivalsQuery("Import", "", "PAK"));
        Assert.Equal(new PendingArrivalFilter("Import", "", "PAK"), repository.LastFilter);

        // "all" in another case is a value, as in the legacy C# string comparison.
        await Handler(repository).HandleAsync(new GetPendingArrivalsQuery("Local", "all", ""));
        Assert.Equal(new PendingArrivalFilter("Local", "all", ""), repository.LastFilter);
    }

    [Fact]
    public async Task Maps_the_three_result_sets_in_order()
    {
        var etd = new DateTime(2026, 10, 17);
        var repository = new FakeConfirmArrivalRepository
        {
            Pending = new PendingArrivalSet(
                [
                    new PendingArrival
                    {
                        RcvNo = "R0001", ArrivalDate = new DateTime(2026, 10, 18, 14, 30, 0), ContractNo = "C1-01", ItemNo = "I1",
                        ShipperCode = "S1", ShipperName = null, CargoType = "Carton", Warehouse = "JO JO WEB", Ctns = 10, Pcs = 120,
                        GrossWgt = 55.5m, Cbm = 1.234m, InboundVesselOrderNo = 1, InboundBookingDate = etd, ConfirmArriveStatus = "",
                        InboundEtd = etd, InboundContainerOrderNo = 2, Country = "IND"
                    },
                    new PendingArrival { RcvNo = "R0002" },
                ],
                [new PendingArrivalSupplier { ShipperCode = "S1", ShipperName = "Supplier 1" }],
                [new PendingArrivalContainer { InboundEtd = etd, InboundVesselOrderNo = 1, InboundContainerOrderNo = 2, VesselName = "V", LoadReference = "L", ContainerNo = "CN", ContainerType = "40HC" }]),
        };

        var result = await Handler(repository).HandleAsync(new GetPendingArrivalsQuery("Import", "All", "All"));

        Assert.True(result.IsSuccess);
        var dto = result.Data!;
        Assert.Equal(["R0001", "R0002"], dto.Contracts.Select(c => c.RcvNo));
        Assert.Equal(
            new PendingContractDto("R0001", new DateTime(2026, 10, 18, 14, 30, 0), "C1-01", "I1", "S1", null, "Carton", "JO JO WEB",
                10, 120, 55.5m, 1.234m, 1, etd, "", etd, 2, "IND"),
            dto.Contracts[0]);
        Assert.Equal(new PendingSupplierDto("S1", "Supplier 1"), Assert.Single(dto.Suppliers));
        Assert.Equal(new PendingContainerDto(etd, 1, 2, "V", "L", "CN", "40HC"), Assert.Single(dto.Containers));
    }

    [Fact]
    public async Task Rejects_values_longer_than_the_columns()
    {
        var repository = new FakeConfirmArrivalRepository();

        await Assert.ThrowsAsync<ValidationException>(() =>
            Handler(repository).HandleAsync(new GetPendingArrivalsQuery("Import", new string('x', 51), "All")));
        Assert.Null(repository.LastFilter);
    }
}

public class GetConfirmArrivalLookupsHandlerTests
{
    [Fact]
    public async Task Dcs_keep_the_repository_order()
    {
        var repository = new FakeConfirmArrivalRepository
        {
            Dcs = [new DestWarehouse { WhDes = "Aramex Fulfillment Centre" }, new DestWarehouse { WhDes = "JO JO WEB" }],
        };

        var result = await new GetConfirmArrivalDcsHandler(repository).HandleAsync(new GetConfirmArrivalDcsQuery());

        Assert.Equal([new ArrivalDcDto("Aramex Fulfillment Centre"), new ArrivalDcDto("JO JO WEB")], result.Data);
    }

    [Fact]
    public async Task Countries_carry_code_and_name()
    {
        var repository = new FakeConfirmArrivalRepository
        {
            Countries = [new Country { CountryCode = "IND", CountryName = "India" }],
        };

        var result = await new GetConfirmArrivalCountriesHandler(repository).HandleAsync(new GetConfirmArrivalCountriesQuery());

        Assert.Equal([new ArrivalCountryDto("IND", "India")], result.Data);
    }
}
