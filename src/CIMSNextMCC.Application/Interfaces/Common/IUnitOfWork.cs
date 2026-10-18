using System.Data;

namespace CIMSNextMCC.Application.Interfaces.Common;

public interface IUnitOfWork
{
    IDbTransaction? CurrentTransaction { get; }
    void Begin();
    void Commit();
    void Rollback();
}
