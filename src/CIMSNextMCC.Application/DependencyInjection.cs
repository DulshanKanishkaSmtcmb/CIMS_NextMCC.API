using CIMSNextMCC.Application.Arrivals.ConfirmArrival;
using CIMSNextMCC.Application.Common.Security;
using CIMSNextMCC.Application.MasterData.Country;
using CIMSNextMCC.Application.MasterData.DC;
using CIMSNextMCC.Application.MasterData.Ports;
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

        return services;
    }
}
