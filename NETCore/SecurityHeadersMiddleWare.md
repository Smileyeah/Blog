### 用于前端文件请求头的安全约束

```
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;

namespace Microsoft.AspNetCore.Builder
{
    public static class SecurityHeadersMiddleWare
    {
        public static IApplicationBuilder UseNetEscapadesSecurityHeaders(this IApplicationBuilder app)
        {
            var configuration = app.ApplicationServices.GetRequiredService<IConfiguration>();

            var ipAddress = string.Empty;

            var parseIpAddress = IPAddress.Parse(configuration["WebApi:IpAddress"]?.ToString()) ?? IPAddress.Any;

            var httpPort = configuration["WebApi:HttpPort"]?.ToString();

            var httpsPort = configuration["WebApi:HttpsPort"]?.ToString();

            if (parseIpAddress.ToString().Trim().Equals("0.0.0.0"))
            {
                ipAddress = "*";
            }
            else
            {
                ipAddress = parseIpAddress.ToString();
            }

            var platformAddress = new List<string>();

            if (!string.IsNullOrEmpty(httpPort))
            {
                platformAddress.Add($"http://{ipAddress}:{httpPort}");
            }

            if (!string.IsNullOrEmpty(httpsPort))
            {
                platformAddress.Add($"https://{ipAddress}:{httpsPort}");
            }

            var cspAllowOrigins = configuration.GetSection("CSPAllowOrigins").Get<List<string>>();

            if (cspAllowOrigins == null || cspAllowOrigins.Count <= 0)
            {
                cspAllowOrigins = platformAddress;
            }
            else
            {
                cspAllowOrigins = platformAddress.Concat(cspAllowOrigins).ToList();
            }

            cspAllowOrigins = cspAllowOrigins.Distinct().ToList();

            if (!cspAllowOrigins.Any())
            {
                ArgumentNullException.ThrowIfNull($"【{cspAllowOrigins}】安全策略的“Content-Security-Policy”配置为空");
            }

            var policyCollection = new HeaderPolicyCollection()
              .RemoveServerHeader()
              .AddXssProtectionBlock()
              // .AddContentTypeOptionsNoSniff()
              .AddReferrerPolicyNoReferrer()
              .AddReferrerPolicySameOrigin()
              .AddFrameOptionsSameOrigin()
              .AddStrictTransportSecurityMaxAgeIncludeSubDomainsAndPreload()
              .AddContentSecurityPolicy(builder =>
              {
                  var currentCSP = configuration.GetSection("CSPAllowOrigins").Get<List<string>>();

                  if (currentCSP != null && currentCSP.Count == 1 && currentCSP[0] == "*")
                  {
                      builder.AddDefaultSrc().Self();

                      builder.AddStyleSrc().Self().UnsafeInline();

                      builder.AddScriptSrc().From(cspAllowOrigins).UnsafeInline().UnsafeEval();
                  }
                  else
                  {
                      builder.AddStyleSrc().UnsafeInline()/*.WithHash256("+oGcdj5BhO6SoiIGYIkPOMYi7d2h2Pp/bkJLBfYL+kk=")*/.From(cspAllowOrigins);

                      builder.AddScriptSrc().UnsafeInline().UnsafeEval().Blob()/*.WithHash256("/epqQuRElKW1Z83z1Sg8Bs2MKi99Nrq41Z3fnS2Nrgk=")*/.From(cspAllowOrigins);
                  }

                  builder.AddImgSrc().Self().Data().Blob().From(cspAllowOrigins);

                  builder.AddFontSrc().Self().Data();

                  builder.AddFrameAncestors().Self();

                  builder.AddFrameSrc().Self().Blob().From(cspAllowOrigins);

                  builder.AddBaseUri().Self().From(cspAllowOrigins);

                  builder.AddObjectSrc().None();

                  builder.AddMediaSrc().Self().From(cspAllowOrigins);
              });

            policyCollection.ApplyDocumentHeadersToContentTypes(DocumentHeaderContentTypePrefixes);

            app.UseSecurityHeaders(policyCollection);

            return app;
        }

        internal static string[]? DocumentHeaderContentTypePrefixes { get; set; } =
            new string[] { "text/html", "application/javascript", "text/javascript", "application/json", "application/x-font-ttf", "application/font-woff", "font/woff2" };
    }
}


```

