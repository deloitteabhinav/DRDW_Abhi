public class TRAK_Webhook {

    public class Sender {
        public String login;
        public Integer id;
        public String avatar_url;
        public String gravatar_id;
        public String url;
        public String html_url;
        public String followers_url;
        public String following_url;
        public String gists_url;
        public String starred_url;
        public String subscriptions_url;
        public String organizations_url;
        public String repos_url;
        public String events_url;
        public String received_events_url;
        public String type_x;
        public Boolean site_admin;
    }

    public class Commits {
        public String id;
        public String tree_id;
        public Boolean distinct;
        public String message;
        public String timestamp;
        public String url;
        public Author author;
        public Author committer;
        public List<String> added;
        public List<Removed> removed;
        public List<String> modified;
    }

    public class Owner {
        public String name;
        public String email;
    }

    public class Repository {
        public Integer id;
        public String name;
        public String full_name;
        public Owner owner;
        public Boolean private_x;
        public String html_url;
        public String description;
        public Boolean fork;
        public String url;
        public String forks_url;
        public String keys_url;
        public String collaborators_url;
        public String teams_url;
        public String hooks_url;
        public String issue_events_url;
        public String events_url;
        public String assignees_url;
        public String branches_url;
        public String tags_url;
        public String blobs_url;
        public String git_tags_url;
        public String git_refs_url;
        public String trees_url;
        public String statuses_url;
        public String languages_url;
        public String stargazers_url;
        public String contributors_url;
        public String subscribers_url;
        public String subscription_url;
        public String commits_url;
        public String git_commits_url;
        public String comments_url;
        public String issue_comment_url;
        public String contents_url;
        public String compare_url;
        public String merges_url;
        public String archive_url;
        public String downloads_url;
        public String issues_url;
        public String pulls_url;
        public String milestones_url;
        public String notifications_url;
        public String labels_url;
        public String releases_url;
        public String deployments_url;
        public Integer created_at;
        public String updated_at;
        public Integer pushed_at;
        public String git_url;
        public String ssh_url;
        public String clone_url;
        public String svn_url;
        public Object homepage;
        public Integer size;
        public Integer stargazers_count;
        public Integer watchers_count;
        public String language;
        public Boolean has_issues;
        public Boolean has_downloads;
        public Boolean has_wiki;
        public Boolean has_pages;
        public Integer forks_count;
        public Object mirror_url;
        public Integer open_issues_count;
        public Integer forks;
        public Integer open_issues;
        public Integer watchers;
        public String default_branch;
        public Integer stargazers;
        public String master_branch;
        public String organization;
    }

    public class Organization {
        public String login;
        public Integer id;
        public String url;
        public String repos_url;
        public String events_url;
        public String hooks_url;
        public String issues_url;
        public String members_url;
        public String public_members_url;
        public String avatar_url;
        public String description;
    }

    public String ref;
    public String before;
    public String after;
    public Boolean created;
    public Boolean deleted;
    public Boolean forced;
    public Object base_ref;
    public String compare;
    public List<Commits> commits;
    public Commits head_commit;
    public Repository repository;
    public Owner pusher;
    public Organization organization;
    public Sender sender;

    public class Author {
        public String name;
        public String email;
        public String username;
    }

    public class Removed {
    }

    
    public static TRAK_Webhook parse(String json) {
        return (TRAK_Webhook) System.JSON.deserialize(json, TRAK_Webhook.class);
    }
}