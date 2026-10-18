using System.Data;
using CIMSNextMCC.Application.Interfaces.Common;

namespace CIMSNextMCC.Infrastructure.Data;

public class UnitOfWork : IUnitOfWork
{
    private readonly IDbConnection _connection;

    public UnitOfWork(IDbConnection connection)
    {
        _connection = connection;
    }

    public IDbTransaction? CurrentTransaction { get; private set; }

    public void Begin()
    {
        CurrentTransaction ??= _connection.BeginTransaction();
    }

    public void Commit()
    {
        CurrentTransaction?.Commit();
        CurrentTransaction?.Dispose();
        CurrentTransaction = null;
    }

    public void Rollback()
    {
        CurrentTransaction?.Rollback();
        CurrentTransaction?.Dispose();
        CurrentTransaction = null;
    }
}
