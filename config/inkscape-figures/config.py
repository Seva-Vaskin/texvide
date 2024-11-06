def latex_template(name, title):
    return '\n'.join((r"\begin{figure}[ht]",
                      r"    \centering",
                      rf"    \incfig{{{name}}}",
                      rf"    \caption{{{title}}}",
                      rf"    \label{{fig:{name}}}",
                      r"\end{figure}"))
