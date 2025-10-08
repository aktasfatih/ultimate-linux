# Claude Code Agents - Quick Reference

This file lists all installed agents and their use cases for your SaaS development workflow.

## 🎯 Quick Selection Guide

### When building a new feature:
1. **System Architect** - Overall architecture and tech decisions
2. **Backend Architect** - API and database design
3. **Frontend Developer** / **Next.js Developer** - UI implementation
4. **Mobile App Developer** - React Native implementation

### When fixing bugs:
1. **Code Reviewer** - Identify issues and suggest fixes
2. **Backend Security Coder** / **Frontend Security Coder** - Security-related bugs
3. **Database Optimizer** - Database performance issues

### When optimizing:
1. **Database Optimizer** - Query and schema optimization
2. **Database Optimization Expert** - Advanced performance tuning
3. **Performance Optimizer** (if available) - Full-stack performance

### When documenting:
1. **Technical Documentation Writer** - User docs, guides
2. **API Documenter** - OpenAPI/Swagger specs
3. **Docs Architect** - Comprehensive documentation

### When managing:
1. **Project Coordinator** - Backlog, requirements, coordination
2. **Product Manager** - Product strategy and features
3. **Business Analyst** - Metrics, KPIs, reporting

## 📋 Full Agent List by Category

### Frontend Development
| Agent | Best For |
|-------|----------|
| `frontend-developer.md` | React components, responsive layouts, client-side state |
| `voltag-nextjs-developer.md` | Next.js 14+ with App Router, SSR, ISR |
| `voltag-react-specialist.md` | React 18+ patterns, hooks, performance |
| `typescript-pro.md` | Advanced TypeScript, type systems |
| `javascript-pro.md` | Modern JavaScript ES6+, async patterns |
| `frontend-security-coder.md` | XSS prevention, CSP, client-side security |

### Backend Development
| Agent | Best For |
|-------|----------|
| `backend-architect.md` | RESTful API design, microservices, schemas |
| `backend-implementation.md` | Python/FastAPI implementation, business logic |
| `voltag-backend-developer.md` | Backend development best practices |
| `voltag-python-pro.md` | Python 3.11+, FastAPI, Django |
| `system-architect.md` | System architecture, technology decisions |
| `backend-security-coder.md` | Secure backend coding, API security |

### Mobile Development
| Agent | Best For |
|-------|----------|
| `mobile-app-developer.md` | React Native, Flutter, mobile-specific features |
| `voltag-mobile-developer.md` | Mobile development best practices |

### API & Integration
| Agent | Best For |
|-------|----------|
| `api-design-integration-expert.md` | REST/GraphQL design, integrations |
| `voltag-api-designer.md` | API architecture, REST and GraphQL |
| `api-documenter.md` | OpenAPI/Swagger documentation |
| `graphql-architect.md` | GraphQL schemas, resolvers, federation |

### Database (Supabase/PostgreSQL)
| Agent | Best For |
|-------|----------|
| `voltag-postgres-pro.md` | PostgreSQL/Supabase optimization |
| `database-optimization-expert.md` | Schema design, query optimization |
| `database-optimizer.md` | Query performance, index design |
| `database-admin.md` | Database operations, backups, monitoring |
| `voltag-sql-pro.md` | SQL expertise |
| `voltag-db-optimizer.md` | Database performance tuning |

### Security & Compliance
| Agent | Best For |
|-------|----------|
| `security-auditor.md` | Vulnerability assessment, OWASP compliance |
| `security-compliance-expert.md` | Security frameworks, data protection |
| `voltag-security-auditor.md` | Security vulnerability detection |
| `voltag-legal-advisor.md` | Legal compliance, contracts, privacy |

### Project Management
| Agent | Best For |
|-------|----------|
| `project-coordinator.md` | Sprint planning, backlog management |
| `voltag-product-manager.md` | Product strategy, feature prioritization |
| `business-analyst.md` | Metrics, KPIs, business reporting |

### Code Quality & Documentation
| Agent | Best For |
|-------|----------|
| `code-reviewer.md` | Code review, security, production reliability |
| `technical-documentation-writer.md` | Technical docs, architecture guides |
| `docs-architect.md` | Comprehensive documentation |

## 🚀 Common Workflows

### Building a New SaaS Feature
```
1. System Architect → Plan architecture
2. Backend Architect → Design API endpoints and database schema
3. Database Optimization Expert → Optimize schema
4. Backend Implementation → Implement Python/FastAPI endpoints
5. Frontend Developer / Next.js Developer → Build UI
6. Mobile App Developer → Build React Native screens
7. API Documenter → Document endpoints
8. Code Reviewer → Review implementation
9. Security Auditor → Security review
10. Technical Documentation Writer → User documentation
```

### Optimizing Database Performance
```
1. Database Optimizer → Identify slow queries
2. Postgres Pro → PostgreSQL-specific optimizations
3. Database Optimization Expert → Advanced schema tuning
4. Backend Implementation → Update queries in code
5. Code Reviewer → Review changes
```

### Security Audit Workflow
```
1. Security Auditor → Full vulnerability assessment
2. Backend Security Coder → Fix backend issues
3. Frontend Security Coder → Fix frontend issues
4. Security Compliance Expert → Ensure regulatory compliance
5. Legal Advisor → Review privacy/legal aspects
6. Code Reviewer → Final review
```

### Documentation Sprint
```
1. Docs Architect → Plan documentation structure
2. API Documenter → OpenAPI/Swagger specs
3. Technical Documentation Writer → User guides, setup docs
4. Code Reviewer → Review documentation quality
```

## 💡 Tips

- **Use multiple agents in sequence** for complex tasks
- **Start with architects** for planning, then implementation agents
- **Always finish with Code Reviewer** for quality assurance
- **Security Auditor** should review before production
- **Agents are symlinked** - edit any time, changes are instant!

## 🔧 Management Commands

```bash
# List all agents
./install.sh --list-agents

# Agents are in either location (synced via symlink):
ls ~/.claude/agents/
ls ~/Desktop/ultimate-linux/config/claude/agents/

# Add a new agent
vim ~/Desktop/ultimate-linux/config/claude/agents/my-agent.md

# Remove an agent
rm ~/.claude/agents/unwanted-agent.md
```

---

*Generated: January 2025*
*Tech Stack: Next.js, React, React Native, Python, Supabase*
