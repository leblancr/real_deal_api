```toml
name = 'New Project'
id = 'a9f444a2-9887-4421-96e4-d522b321c91b'

[[environmentGroups]]
name = 'Default'
environments = ['Development']

[[apis]]
name = 'real_deal_API'
```

#### Init Script

```js
// Define the base URL for the API
const BASE_URL = "https://localhost:4000";

// Export them so they can be used in requests
return { BASE_URL };

```
