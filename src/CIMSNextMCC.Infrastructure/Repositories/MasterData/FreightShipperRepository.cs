using System.Data;
using CIMSNextMCC.Application.Common.Exceptions;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using CIMSNextMCC.Domain.Tenancy;
using Dapper;
using Microsoft.Data.SqlClient;

namespace CIMSNextMCC.Infrastructure.Repositories.MasterData;

/// <summary>
/// Ports legacy DataApi/getAirShipperList, getAirShipperData, getSeaShipperList and getSeaShipperData: the same selects on
/// the three-part names <c>[AirFreight].dbo.Shipper</c> / <c>[SeaFreight].dbo.Shipper</c>, run on the tenant's Air and Sea
/// connections (legacy <c>ListTableLoadAir</c> / <c>ListTableLoadSea</c>), read-only, outside the unit of work.
/// A database that is not configured or not reachable is a 503 (legacy logged the error and returned an empty table).
/// </summary>
public class FreightShipperRepository(ITenantConnectionFactory connections) : IFreightShipperRepository
{
    public const string AirUnavailable = "AIR_DATABASE_UNAVAILABLE";
    public const string SeaUnavailable = "SEA_DATABASE_UNAVAILABLE";

    public Task<IReadOnlyList<FreightShipper>> GetAirShippersAsync(CancellationToken cancellationToken = default) =>
        QueryAsync<FreightShipper>(
            DbName.Air,
            AirUnavailable,
            "SELECT t1.ShCode, t1.ShName, t1.ShAdd1, t1.ShAdd2, t1.ShAdd3, t1.ShAdd4 FROM [AirFreight].dbo.Shipper t1 ORDER BY t1.ShCode",
            null,
            cancellationToken);

    public async Task<FreightShipperName?> FindAirShipperAsync(string shCode, CancellationToken cancellationToken = default) =>
        (await QueryAsync<FreightShipperName>(
            DbName.Air,
            AirUnavailable,
            "SELECT t1.ShCode, t1.ShName FROM [AirFreight].dbo.Shipper t1 WHERE t1.ShCode = @ShCode",
            Code(shCode),
            cancellationToken)).FirstOrDefault();

    public Task<IReadOnlyList<FreightShipper>> GetSeaShippersAsync(CancellationToken cancellationToken = default) =>
        QueryAsync<FreightShipper>(
            DbName.Sea,
            SeaUnavailable,
            "SELECT t1.ShCode, t1.ShName, t1.ShAdd1, t1.ShAdd2, t1.ShAdd3, t1.ShAdd4 FROM [SeaFreight].dbo.Shipper t1 ORDER BY t1.ShCode",
            null,
            cancellationToken);

    public async Task<FreightShipperName?> FindSeaShipperAsync(string shCode, CancellationToken cancellationToken = default) =>
        (await QueryAsync<FreightShipperName>(
            DbName.Sea,
            SeaUnavailable,
            "SELECT t1.ShCode, t1.ShName FROM [SeaFreight].dbo.Shipper t1 WHERE t1.ShCode = @ShCode",
            Code(shCode),
            cancellationToken)).FirstOrDefault();

    private static DynamicParameters Code(string shCode)
    {
        var parameters = new DynamicParameters();
        parameters.Add("@ShCode", shCode, DbType.String, size: 5);
        return parameters;
    }

    private async Task<IReadOnlyList<T>> QueryAsync<T>(
        DbName database,
        string unavailableCode,
        string sql,
        DynamicParameters? parameters,
        CancellationToken cancellationToken)
    {
        try
        {
            using var connection = connections.Open(database);
            var rows = await connection.QueryAsync<T>(new CommandDefinition(sql, parameters, cancellationToken: cancellationToken));
            return rows.AsList();
        }
        catch (Exception ex) when (ex is InvalidOperationException or SqlException)
        {
            throw new AppException(unavailableCode, 503);
        }
    }
}
