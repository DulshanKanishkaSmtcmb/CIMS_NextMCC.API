using CIMSNextMCC.Application.Arrivals.ConfirmArrival;
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

        return services;
    }
}
