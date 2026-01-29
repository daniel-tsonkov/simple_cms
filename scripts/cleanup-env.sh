#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🧹 Cleaning up Simple CMS DevOps Environment${NC}"
echo "================================================"

# Kill port forwards
echo -e "\n${YELLOW}🔌 Stopping port forwards...${NC}"
pkill -f "port-forward.*argocd" || true
pkill -f "port-forward.*grafana" || true
pkill -f "port-forward.*prometheus" || true
echo -e "${GREEN}✅ Port forwards stopped${NC}"

# Delete Kind cluster
echo -e "\n${YELLOW}🗑️  Deleting Kind cluster...${NC}"
if kind get clusters | grep -q "simple-cms"; then
    kind delete cluster --name simple-cms
    echo -e "${GREEN}✅ Kind cluster deleted${NC}"
else
    echo -e "${YELLOW}⚠️  No cluster found${NC}"
fi

echo -e "\n${GREEN}✅ Cleanup complete!${NC}"