using CIMSNextMCC.Application.Arrivals.ConfirmArrival;
using CIMSNextMCC.Application.Common.Security;
using CIMSNextMCC.Application.MasterData.Country;
using CIMSNextMCC.Application.MasterData.DC;
using CIMSNextMCC.Application.MasterData.PMMaster;
using CIMSNextMCC.Application.MasterData.PmSupplier;
using CIMSNextMCC.Application.MasterData.Ports;
using CIMSNextMCC.Application.MasterData.ProductCategory;
using CIMSNextMCC.Application.MasterData.Supplier;
using CIMSNextMCC.Application.Reference.FieldCaptions;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;

namespace CIMSNextMCC.Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        // Every AbstractValidator<T> in this assembly (one per command / query that has input to validate).
        services.AddValidatorsFromAssembly(typeof(DependencyInjection).Assembly);

        // One handler per endpoint.
        services.AddScoped<GetFieldCaptionsHandler>();

        // Arrivals / Confirm Arrival (legacy Data/ConfirmArrival).
        services.AddScoped<GetConfirmArrivalDcsHandler>();
        services.AddScoped<GetConfirmArrivalCountriesHandler>();
        services.AddScoped<GetPendingArrivalsHandler>();
        services.AddScoped<ConfirmArrivalHandler>();

        // Master data wave 1a: File/Country, File/Ports, File/DC.
        services.AddScoped<LegacyAuditUserResolver>();
        services.AddScoped<GetCountryListHandler>();
        services.AddScoped<GetCountryDataHandler>();
        services.AddScoped<FindCountryNameHandler>();
        services.AddScoped<SaveCountryDataHandler>();
        services.AddScoped<GetPortListHandler>();
        services.AddScoped<GetPortDataHandler>();
        services.AddScoped<FindPortNameHandler>();
        services.AddScoped<SavePortDataHandler>();
        services.AddScoped<GetDcListHandler>();
        services.AddScoped<GetDcDataHandler>();
        services.AddScoped<SaveDcDataHandler>();

        // Master data wave 1c: File/PMMaster, File/ProductCategory.
        services.AddScoped<GetPmListHandler>();
        services.AddScoped<GetPmDataHandler>();
        services.AddScoped<GetPmCategoriesHandler>();
        services.AddScoped<SavePmDataHandler>();
        services.AddScoped<GetChainCodesHandler>();
        services.AddScoped<GetChainRangesHandler>();
        services.AddScoped<SaveChainCodeHandler>();

        // Master data wave 1b: File/Supplier, File/PmSupplier.
        services.AddScoped<GetSupplierListHandler>();
        services.AddScoped<GetSupplierDataHandler>();
        services.AddScoped<FindSupplierNameHandler>();
        services.AddScoped<SaveSupplierDataHandler>();
        services.AddScoped<GetAirShipperListHandler>();
        services.AddScoped<GetAirShipperDataHandler>();
        services.AddScoped<GetSeaShipperListHandler>();
        services.AddScoped<GetSeaShipperDataHandler>();
        services.AddScoped<GetPmSupplierListHandler>();
        services.AddScoped<GetPmSupplierDataHandler>();
        services.AddScoped<SavePmSupplierDataHandler>();

        return services;
    }
}
