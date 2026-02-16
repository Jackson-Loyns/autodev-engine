# Web Search Rule

**Priority**: HIGH

## When to Search the Web

### Automatic Triggers
Search the web when the user asks for:

1. **Latest Information**
   - "What's the latest version of..."
   - "Recent updates about..."
   - "Current best practices for..."

2. **Documentation/APIs**
   - "How to use [library/API]..."
   - "Documentation for..."
   - "API reference for..."

3. **Examples/Tutorials**
   - "Show me examples of..."
   - "Find a tutorial on..."
   - "How do I [task]..."

4. **Troubleshooting**
   - "Why is [error] happening..."
   - "How to fix [error]..."
   - "Common issues with..."

5. **Technology Comparison**
   - "Compare [A] vs [B]..."
   - "Which is better..."
   - "Pros and cons of..."

## Tool Selection

### `search_web` - General Search
Use for:
- ✅ Finding latest information
- ✅ Getting multiple perspectives
- ✅ Discovering solutions to problems
- ✅ Comparing technologies

**Example**:
```
User: "What's the latest React best practices?"
Agent: [Calls search_web("React 2024 best practices")]
Agent: [Summarizes top 3-5 results]
```

### `read_url_content` - Specific Documentation
Use for:
- ✅ Reading official docs
- ✅ Following specific links user provides
- ✅ Extracting code examples from blogs
- ✅ Getting detailed API reference

**Example**:
```
User: "Read this article: https://example.com/tutorial"
Agent: [Calls read_url_content("https://example.com/tutorial")]
Agent: [Summarizes key points]
```

### `browser_subagent` - Complex Interactions
Use for:
- ✅ Multi-step web navigation
- ✅ Interactive documentation
- ✅ Filling forms / testing web apps
- ✅ Capturing screenshots

**Example**:
```
User: "Check how the login flow looks on example.com"
Agent: [Calls browser_subagent to navigate and screenshot]
```

## Search Workflow

### Pattern 1: Quick Answer
```
1. search_web(query)
2. Read top 3 results summaries
3. Synthesize answer
4. Cite sources with URLs
```

### Pattern 2: Deep Research
```
1. search_web(broad query)
2. identify best resource URL
3. read_url_content(specific URL)
4. Extract relevant information
5. Provide detailed answer with citations
```

### Pattern 3: Code Example Hunting
```
1. search_web("[library] code examples")
2. find GitHub repos or blog posts
3. read_url_content(example URL)
4. Extract code snippet
5. Adapt to user's use case
```

## Best Practices

### Always Cite Sources
```markdown
Based on [Source Name](URL):
- Key point 1
- Key point 2
```

### Verify Information
If multiple sources conflict:
- ✅ Search for official documentation
- ✅ Prioritize recent sources (2023+)
- ✅ Note discrepancies to user

### Don't Hallucinate
```
❌ "I think the API works like..."
✅ [Searches web] "According to the official docs at [URL]..."
```

### Combine with Local Knowledge
```
1. Check if you already know the answer
2. If uncertain or need latest info → search web
3. Combine web results with your expertise
4. Provide comprehensive answer
```

## Rate Limiting

### Don't Over-Search
- ❌ Don't search for every single question
- ✅ Use search when you need latest/specific info
- ✅ Rely on your training when appropriate

### Batch Searches
If user has multiple related questions:
```
User: "I need info on React, Next.js, and Tailwind"
Agent: [Calls 3 parallel search_web calls]
Agent: [Synthesizes all results together]
```

## Examples

### Example 1: Latest Version
```
User: "What's the latest Node.js LTS version?"
Agent: [search_web("Node.js LTS version 2024")]
Agent: "According to nodejs.org, the latest LTS is Node.js 20.11..."
```

### Example 2: Documentation
```
User: "How do I use Stripe webhooks?"
Agent: [search_web("Stripe webhooks documentation")]
Agent: [read_url_content("https://stripe.com/docs/webhooks")]
Agent: "Here's how to set up Stripe webhooks: [detailed steps]"
```

### Example 3: Troubleshooting
```
User: "I'm getting CORS error with fetch API"
Agent: [search_web("CORS error fetch API fix")]
Agent: "Based on MDN and Stack Overflow, here are 3 solutions: ..."
```

## Integration with Agents

### Planner Agent
- Search for architecture patterns
- Find reference implementations
- Compare technology options

### Implementer Agent
- Find code examples
- Read API documentation
- Look up syntax/usage

### TDD Guide
- Search for testing best practices
- Find test examples
- Look up testing library docs

### Code Reviewer
- Search for security best practices
- Find performance optimization techniques
- Look up coding standards
