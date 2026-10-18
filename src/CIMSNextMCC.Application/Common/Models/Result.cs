namespace CIMSNextMCC.Application.Common.Models;

public class Result
{
    public bool IsSuccess { get; protected set; }
    public string MessageCode { get; protected set; }

    protected Result(bool isSuccess, string messageCode)
    {
        IsSuccess = isSuccess;
        MessageCode = messageCode;
    }

    public static Result Success(string messageCode = "SUCCESS") => new(true, messageCode);

    public static Result Failure(string messageCode) => new(false, messageCode);
}

public class Result<T> : Result
{
    public T? Data { get; private set; }

    private Result(bool isSuccess, string messageCode, T? data)
        : base(isSuccess, messageCode)
    {
        Data = data;
    }

    public static Result<T> Success(T data, string messageCode = "SUCCESS") => new(true, messageCode, data);

    public static new Result<T> Failure(string messageCode) => new(false, messageCode, default);
}
