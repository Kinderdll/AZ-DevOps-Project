using Microsoft.AspNetCore.Mvc;
using Moq;
using Shopping.Client.Controllers;
using Shopping.Client.Models;
using System.Net.Http;
using Xunit;

namespace Shopping.Client.Tests
{
    public class HomeControllerTests
    {
        [Fact]
        public async Task Index_ReturnsViewWithProductList()
        {
            // Arrange
            var httpClientMock = new Mock<HttpClient>();
            httpClientMock.Setup(mock => mock.GetAsync("/Product"))
                .ReturnsAsync(new HttpResponseMessage
                {
                    StatusCode = System.Net.HttpStatusCode.OK,
                    Content = new StringContent("[{\"Id\":1,\"Name\":\"Product 1\"},{\"Id\":2,\"Name\":\"Product 2\"}]")
                });

            var httpClientFactoryMock = new Mock<IHttpClientFactory>();
            httpClientFactoryMock.Setup(mock => mock.CreateClient("ShoppingAPIClient"))
                .Returns(httpClientMock.Object);

            var controller = new HomeController(null, httpClientFactoryMock.Object);

            // Act
            var result = await controller.Index();

            // Assert
            var viewResult = Assert.IsType<ViewResult>(result);
            var model = Assert.IsAssignableFrom<IEnumerable<Product>>(viewResult.ViewData.Model);
            Assert.Equal(2, model.Count());
        }
    }
}
