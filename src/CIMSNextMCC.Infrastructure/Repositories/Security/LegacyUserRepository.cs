using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;
using CIMSNextMCC.Application.Interfaces.Repositories.Security;
using CIMSNextMCC.Domain.Entities.Security;
using Dapper;

namespace CIMSNextMCC.Infrastructure.Repositories.Security;

public class LegacyUserRepository : ILegacyUserRepository
{
    private readonly IDbConnection _connection;
    private readonly IUnitOfWork _unitOfWork;

    public LegacyUserRepository(IDbConnection connection, IUnitOfWork unitOfWork)
    {
        _connection = connection;
        _unitOfWork = unitOfWork;
    }

    public async Task<IReadOnlyList<LegacyUser>> FindByUserNameAsync(string userName, CancellationToken cancellationToken = default)
    {
        // Same match as the legacy login (UserName = @UserName, nvarchar), minus the password check.
        // Only the four columns that go into the cookie; the PassWord column is never read.
        const string sql = """
            SELECT TOP (2) UserName, UserId, UserCategory, UserLevel
            FROM dbo.PwInfo
            WHERE UserName = @UserName
            """;

        var parameters = new { UserName = new DbString { Value = userName, IsAnsi = false, Length = 50 } };
        var rows = await _connection.QueryAsync<LegacyUser>(
            new CommandDefinition(sql, parameters, _unitOfWork.CurrentTransaction, cancellationToken: cancellationToken));

        return rows.AsList();
    }
}
