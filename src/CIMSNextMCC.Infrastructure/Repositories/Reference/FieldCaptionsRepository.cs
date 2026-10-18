using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.Reference;
using CIMSNextMCC.Domain.Entities.Reference;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.Reference;

public class FieldCaptionsRepository : IFieldCaptionsRepository
{
    private readonly IDbConnection _connection;
    private readonly IUnitOfWork _unitOfWork;

    public FieldCaptionsRepository(IDbConnection connection, IUnitOfWork unitOfWork)
    {
        _connection = connection;
        _unitOfWork = unitOfWork;
    }

    public async Task<FldCaptions?> GetAsync(CancellationToken cancellationToken = default)
    {
        // Named columns on purpose: the legacy "select t1.*" plus positional reads is what crossed the captions.
        const string sql = """
            SELECT TOP 1 SysCaption, ContractNoCaption, ItemNoCaption, PONoCaption, DeliveryNoCaption
            FROM dbo.FldCaptions
            """;

        return await _connection.QueryFirstOrDefaultAsync<FldCaptions>(
            new CommandDefinition(sql, transaction: _unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));
    }
}
