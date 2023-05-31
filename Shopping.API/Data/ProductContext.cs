
using MongoDB.Driver;
using Shopping.API.Models;

namespace Shopping.API.Data
{
    public class ProductContext
    {
        public ProductContext(IConfiguration configuration)
        {
            
            var client = new MongoClient(configuration["DatabaseSettings:ConnectionString"]);
            var database = client.GetDatabase(configuration["DatabaseSettings:DatabaseName"]);

            Products = database.GetCollection<Product>(configuration["DatabaseSettings:CollectionName"]);

            //var mongoUrl = MongoUrl.Create(connectionString);
            //var mongoClient = new MongoClient(mongoUrl);
            //var database = mongoClient.GetDatabase(mongoUrl.DatabaseName);
            //Products = database.GetCollection<Product>("Products");

            
            SeedData(Products);
        }

        public IMongoCollection<Product> Products { get; }

        private static void SeedData(IMongoCollection<Product> productCollection)
        {
            bool existProduct = productCollection.Find(p => true).Any();
            if (!existProduct)
            {
                productCollection.InsertManyAsync(GetPreconfiguredProducts());
            }
        }

        private static IEnumerable<Product> GetPreconfiguredProducts()
        {
            return new List<Product>()
            {
                new Product()
            {
                Name = "Phone 1",
                Description = "Phone 2 description",
                Price = 950.00M,
                Category = "Smart Phone"
            },
            new Product()
            {
                Name = "Phone 3",
                Description = "Phone 3 description",
                Price = 950.00M,
                Category = "Smart Phone"
            },
            new Product()
            {
                Name = "Phone 4",
                Description = "Phone 4 description",
                Price = 950.00M,
                Category = "Smart Phone"
            },
            new Product()
            {
                Name = "Phone 5",
                Description = "Phone 5 description",
                Price = 950.00M,
                Category = "Smart Phone"
            },
            new Product()
            {
                Name = "Phone 6",
                Description = "Phone 6 description",
                Price = 950.00M,
                Category = "Smart Phone"
            },
            new Product()
            {
                Name = "Phone 7",
                Description = "Phone 7 description",
                Price = 950.00M,
                Category = "Smart Phone"
            }
            };
        }
    }
}
