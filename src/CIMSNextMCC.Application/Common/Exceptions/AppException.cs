namespace CIMSNextMCC.Application.Common.Exceptions;

/// <summary>A business / request error with a stable code and an HTTP status. Rendered as ProblemDetails.</summary>
public class AppException : Exception
{
    public string MessageCode { get; }

    public int StatusCode { get; }

    public AppException(string messageCode, int statusCode = 400)
        : base(messageCode)
    {
        MessageCode = messageCode;
        StatusCode = statusCode;
    }
}

public class ForbiddenException(string messageCode) : AppException(messageCode, 403);

public class NotFoundException(string messageCode) : AppException(messageCode, 404);
