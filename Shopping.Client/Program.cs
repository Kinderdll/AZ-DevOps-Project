var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
builder.Services.AddHttpClient("ShoppingAPIClient", client =>
{
    //ShoppingAPI URL
    //client.BaseAddress = new Uri("http://shoppingapi:8000/");
    //Get ShoppingAPIUrl from config
    client.BaseAddress = new Uri(builder.Configuration.GetValue<string>("ShoppingAPIUrl"));

}); 
var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
}
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
