### create an Expression AND clause from two expressions


~~~
using System.Linq.Expressions;

internal sealed class ExpressionDelegateVisitor : ExpressionVisitor
{
    private readonly Func<Expression, Expression> m_Visitor;
    private readonly bool m_Recursive;

    public static Expression Visit(Expression exp, Func<Expression, Expression> visitor, bool recursive)
    {
        return new ExpressionDelegateVisitor(visitor, recursive).Visit(exp);
    }

    private ExpressionDelegateVisitor(Func<Expression, Expression> visitor, bool recursive)
    {
        if (visitor == null) throw new ArgumentNullException(nameof(visitor));
        m_Visitor = visitor;
        m_Recursive = recursive;
    }

    public override Expression Visit(Expression node)
    {
        if (m_Recursive)
        {
            return base.Visit(m_Visitor(node));
        }
        else
        {
            var visited = m_Visitor(node);
            if (visited == node) return base.Visit(visited);
            return visited;
        }
    }

}

public static class ExpressionExtensions
{
    public static Expression Visit(this Expression self, Func<Expression, Expression> visitor, bool recursive = false)
    {
        return ExpressionDelegateVisitor.Visit(self, visitor, recursive);
    }

    public static Expression Replace(this Expression self, Expression source, Expression target)
    {
        return self.Visit(x => x == source ? target : x);
    }

    public static Expression<Func<T, bool>> CombineAnd<T>(this Expression<Func<T, bool>> self,
        Expression<Func<T, bool>> other)
    {
        var parameter = Expression.Parameter(typeof(T), "a");
        return Expression.Lambda<Func<T, bool>>(
            Expression.AndAlso(
                self.Body.Replace(self.Parameters[0], parameter),
                other.Body.Replace(other.Parameters[0], parameter)
            ),
            parameter
        );
    }

}
~~~

## 使用方法:

~~~
Expression<Func<int , bool>> leftExp = a => a > 3;
Expression<Func<int , bool>> rightExp = a => a < 7;
var andExp = leftExp.CombineAnd ( rightExp );
~~~

## 来源:

https://stackoverflow.com/questions/12684010/how-to-create-an-expression-and-clause-from-two-expressions
