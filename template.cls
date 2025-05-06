\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{template}[2024/12/19 My custom template class]

% Basierend auf article
\LoadClass[10pt,a4paper]{article}

% ---------------------- Pakete für Layout ----------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{helvet}    % Serifenlose Schrift für Titel und Überschriften
\RequirePackage{ragged2e}
\RequirePackage{lipsum}
\RequirePackage{mathptmx}  % Times-ähnliche Schrift für den Fliesstext
\renewcommand{\sfdefault}{phv}

\RequirePackage{geometry}
\geometry{a4paper, left=3cm, right=3cm, top=2.5cm, bottom=2.5cm}

\RequirePackage{setspace}
\onehalfspacing

\RequirePackage{microtype}
\DisableLigatures{encoding = *, family = * }

\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    citecolor=TealBlue,
    urlcolor=TealBlue
}

\RequirePackage{titlesec}
\titleformat{\section}{\sffamily\Large\bfseries\raggedright}{\thesection}{1em}{} 
\titleformat{\subsection}{\sffamily\large\bfseries\raggedright}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\sffamily\normalsize\bfseries\raggedright}{\thesubsubsection}{1em}{}

\RequirePackage{enumitem}

\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
% Keine Linien:
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
% Seitenzahl unten rechts:
\fancyfoot[R]{\thepage}

% ---------------------- Literatur mit biblatex ----------------------
\RequirePackage[
  style=apa,
  backend=biber,
  giveninits=false,
  uniquename=false,
  language=swissgerman
]{biblatex}

% Befehle zum einfachen Einbinden der Bib-Datei und Ausgeben der Bibliographie:
\newcommand{\AddBibFile}[1]{\addbibresource{#1}}
\newcommand{\PrintBib}{\printbibliography}

\DeclareNameAlias{author}{given-family}
\DeclareNameAlias{editor}{given-family}
\DeclareNameAlias{translator}{given-family}


\DeclareNameFormat{given-family}{%
  \usebibmacro{name:given-family}
    {\namepartfamily}
    {\namepartgiven}
    {\namepartprefix}
    {\namepartsuffix}%
  \usebibmacro{name:andothers}}

\DeclareNameFormat{given-family-used}{%
  \usebibmacro{name:given-family}
    {\namepartfamily}
    {\namepartgiven}
    {\namepartprefix}
    {\namepartsuffix}}

\DeclareNameAlias{author}{given-family}
\DeclareNameAlias{editor}{given-family}
\DeclareNameAlias{translator}{given-family}


% ---------------------- Titel- und Metainformationen ----------------------
\newcommand{\ReportTitle}{}
\newcommand{\ReportAuthor}{}
\newcommand{\ReportDate}{\today}

\newcommand{\SetTitle}[1]{\renewcommand{\ReportTitle}{#1}}
\newcommand{\SetAuthor}[1]{\renewcommand{\ReportAuthor}{#1}}
\newcommand{\SetDate}[1]{\renewcommand{\ReportDate}{#1}}

\makeatletter
\renewcommand{\maketitle}{
    % Titel in serifenlos und linksbündig
    \vspace*{-2em}
    \sffamily
    \raggedright
    {\Large\bfseries \ReportTitle \par}
    \vspace{1em}
    {\footnotesize
        \ReportAuthor \\
        \ReportDate
    }
    \par\vspace{2em}

    % Nach dem Titel wieder zurück zu Times (Serif) und Blocksatz
    \normalfont
    \normalsize
    \rmfamily
    \justifying
}
\makeatother
