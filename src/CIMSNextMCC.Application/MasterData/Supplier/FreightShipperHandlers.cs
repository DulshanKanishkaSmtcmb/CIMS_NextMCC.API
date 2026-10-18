using CIMSNextMCC.Application.Common.Models;
using CIMSNextMCC.Application.Interfaces.Repositories.MasterData;
using CIMSNextMCC.Domain.Entities.MasterData;
using FluentValidation;

namespace CIMSNextMCC.Application.MasterData.Supplier;

public sealed record GetAirShipperListQuery;

public sealed record GetAirShipperDataQuery(string ShCode);

public sealed record GetSeaShipperListQuery;

public sealed record GetSeaShipperDataQuery(string ShCode);

public sealed class GetAirShipperDataValidator : AbstractValidator<GetAirShipperDataQuery>
{
    public GetAirShipperDataValidator() => RuleFor(q => q.ShCode).NotNull().MaximumLength(SupplierRules.FreightCodeLength);
}

public sealed class GetSeaShipperDataValidator : AbstractValidator<GetSeaShipperDataQuery>
{
    public GetSeaShipperDataValidator() => RuleFor(q => q.ShCode).NotNull().MaximumLength(SupplierRules.FreightCodeLength);
}

internal static class FreightShipperMapping
{
    public static FreightShipperDto ToDto(FreightShipper s) => new(s.ShCode, s.ShName, s.ShAdd1, s.ShAdd2, s.ShAdd3, s.ShAdd4);

    public static FreightShipperNameDto ToDto(FreightShipperName s) => new(s.ShCode, s.ShName);
}

/// <summary>
/// Replaces legacy DataApi/getAirShipperList (<c>select ShCode, ShName, ShAdd1..4 from [AirFreight].dbo.Shipper order by
/// ShCode</c>), the "Air Shipper Listing" dialog behind the Shipper Code [AFOS] button.
/// </summary>
public sealed class GetAirShipperListHandler(IFreightShipperRepository repository)
{
    public async Task<Result<IReadOnlyList<FreightShipperDto>>> HandleAsync(
        GetAirShipperListQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        var rows = await repository.GetAirShippersAsync(cancellationToken);
        IReadOnlyList<FreightShipperDto> dtos = rows.Select(FreightShipperMapping.ToDto).ToList();
        return Result<IReadOnlyList<FreightShipperDto>>.Success(dtos);
    }
}

/// <summary>
/// Replaces legacy DataApi/getAirShipperData (<c>select ShCode, ShName from [AirFreight].dbo.Shipper where ShCode = ...</c>),
/// which fills the AFOS shipper name when a code is chosen. 404 <see cref="NotFound"/> when the code does not exist (legacy:
/// an empty table, and the page then leaves the name as it was).
/// </summary>
public sealed class GetAirShipperDataHandler(IFreightShipperRepository repository, IValidator<GetAirShipperDataQuery> validator)
{
    public const string NotFound = "AIR_SHIPPER_NOT_FOUND";

    public async Task<Result<FreightShipperNameDto>> HandleAsync(GetAirShipperDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);
        var row = await repository.FindAirShipperAsync(query.ShCode, cancellationToken);
        return row is null
            ? Result<FreightShipperNameDto>.Failure(NotFound)
            : Result<FreightShipperNameDto>.Success(FreightShipperMapping.ToDto(row));
    }
}

/// <summary>
/// Replaces legacy DataApi/getSeaShipperList (<c>select ShCode, ShName, ShAdd1..4 from [SeaFreight].dbo.Shipper order by
/// ShCode</c>), the "Sea Shipper Listing" dialog behind the Shipper Code [SFOS] button.
/// </summary>
public sealed class GetSeaShipperListHandler(IFreightShipperRepository repository)
{
    public async Task<Result<IReadOnlyList<FreightShipperDto>>> HandleAsync(
        GetSeaShipperListQuery query,
        CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        var rows = await repository.GetSeaShippersAsync(cancellationToken);
        IReadOnlyList<FreightShipperDto> dtos = rows.Select(FreightShipperMapping.ToDto).ToList();
        return Result<IReadOnlyList<FreightShipperDto>>.Success(dtos);
    }
}

/// <summary>
/// Replaces legacy DataApi/getSeaShipperData (<c>select ShCode, ShName from [SeaFreight].dbo.Shipper where ShCode = ...</c>),
/// which fills the SFOS shipper name when a code is chosen. 404 <see cref="NotFound"/> when the code does not exist.
/// </summary>
public sealed class GetSeaShipperDataHandler(IFreightShipperRepository repository, IValidator<GetSeaShipperDataQuery> validator)
{
    public const string NotFound = "SEA_SHIPPER_NOT_FOUND";

    public async Task<Result<FreightShipperNameDto>> HandleAsync(GetSeaShipperDataQuery query, CancellationToken cancellationToken = default)
    {
        ArgumentNullException.ThrowIfNull(query);
        await validator.ValidateAndThrowAsync(query, cancellationToken);
        var row = await repository.FindSeaShipperAsync(query.ShCode, cancellationToken);
        return row is null
            ? Result<FreightShipperNameDto>.Failure(NotFound)
            : Result<FreightShipperNameDto>.Success(FreightShipperMapping.ToDto(row));
    }
}
