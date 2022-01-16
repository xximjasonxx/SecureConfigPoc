using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Azure.Identity;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace DataViewer
{
    public class Program
    {
        private const string AppConfigUrl = "https://appconfig-pocapplication-pojm2j.azconfig.io";

        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.ConfigureAppConfiguration(config =>
                    {
                        config.AddAzureAppConfiguration(appConfig =>
                        {
                            /*var credential = new ClientSecretCredential(
                                "e15b8f94-b657-4f98-a1f2-9df013c37c73",
                                "25392f21-1b93-428c-965b-9576524fdd2b",
                                "rNt7Q~2RDQb-CcNBI_bZGRcdrf4LMLjZ2lMQ5");*/
                            var credential = new ManagedIdentityCredential("93e93c24-c457-4dea-bee3-218b29ae32f1");

                            appConfig.Connect(new Uri(AppConfigUrl), credential)
                                .ConfigureKeyVault(kvConfig =>
                                {
                                    kvConfig.SetCredential(credential);
                                });
                        });
                    }).UseStartup<Startup>();
                });
    }
}
