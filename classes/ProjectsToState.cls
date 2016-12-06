public class ProjectsToState {
    public String state { get; set; }
    public Integer projectsCount { get; set; }

    public ProjectsToState (String state, Integer projectsCount) {
        this.state = state;
        this.projectsCount = projectsCount;
    }
}