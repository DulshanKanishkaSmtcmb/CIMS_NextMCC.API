using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.Arrivals;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Application.Interfaces.Repositories.Reference;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;
using CIMSNextMCC.Domain.Tenancy;
using CIMSNextMCC.Infrastructure.Data;
using CIMSNextMCC.Infrastructure.Identity;
using CIMSNextMCC.Infrastructure.Repositories.Arrivals;
using CIMSNextMCC.Infrastructure.Repositories.MasterData;
using CIMSNextMCC.Infrastructure.Repositories.Reference;
using CIMSNextMCC.Infrastructure.Repositories.Security;
using CIMSNextMCC.Infrastructure.Tenancy;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace CIMSNextMCC.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration configuration)
    {
        // "Tenants" is a top-level array, so it is bound into TenantOptions.Tenants explicitly.
        var tenants = configuration.GetSection(TenantOptions.SectionName).Get<List<TenantConfig>>() ?? [];
        services.Configure<TenantOptions>(options => options.Tenants = tenants);

        services.AddHttpContextAccessor();
        services.AddScoped<ITenantContext, TenantContext>();
        services.AddScoped<ITenantConnectionFactory, TenantConnectionFactory>();
        services.AddScoped<ICurrentUser, CurrentUser>();

        // The tenant's Main database, opened on first use in a request and disposed with the scope.
        // Repositories for the other databases inject ITenantConnectionFactory and call Open(DbName.Cfs|Air|Sea).
        services.AddScoped<IDbConnection>(sp => sp.GetRequiredService<ITenantConnectionFactory>().Open(DbName.Main));
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        services.AddScoped<IFieldCaptionsRepository, FieldCaptionsRepository>();
        services.AddScoped<IConfirmArrivalRepository, ConfirmArrivalRepository>();
        services.AddScoped<ICountryRepository, CountryRepository>();
        services.AddScoped<IPortRepository, PortRepository>();
        services.AddScoped<IDcRepository, DcRepository>();
        services.AddScoped<IPackingMaterialRepository, PackingMaterialRepository>();
        services.AddScoped<IContractChainCodeRepository, ContractChainCodeRepository>();

        // Legacy cookie bridge (docs/09 section 4.3); the cookie scheme itself is AddLegacyCookie. Deleted in Phase 4.
        services.AddScoped<ILegacyUserRepository, LegacyUserRepository>();

        return services;
    }
}
