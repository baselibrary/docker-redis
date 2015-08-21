NAME = quay.io/baselibrary/redis
REPO = git@github.com:baselibrary/docker-redis.git
TAGS = 2.8 3.0

all: build

build: $(TAGS)

release: $(TAGS)
	docker push ${NAME}

sync-branches:
	git fetch $(REPO) master
	@$(foreach tag, $(TAGS), git branch -f $(tag) FETCH_HEAD;)
	@$(foreach tag, $(TAGS), git push $(REPO) $(tag);)
	@$(foreach tag, $(TAGS), git branch -D $(tag);)

.PHONY: $(TAGS)
$(TAGS):
	docker build -t $(NAME):$@ $@
