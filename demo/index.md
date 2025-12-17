---
layout: default
title: Jekyll GitHub Code Demo
---

## Full File Embedding

Embed an entire file from any public GitHub repository:

<div class="usage-code">
{% raw %}{% github_code r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile %}{% endraw %}
</div>

{% github_code r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile %}

<div class="divider"></div>

## Line Range Selection

Show only specific lines with `#L5-L12` syntax:

<div class="usage-code">
{% raw %}{% github_code r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile#L5-L12 %}{% endraw %}
</div>

{% github_code r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile#L5-L12 %}

<div class="divider"></div>

## Single Line

Extract just one line with `#L10`:

<div class="usage-code">
{% raw %}{% github_code r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile#L1 %}{% endraw %}
</div>

{% github_code r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile#L1 %}

<div class="divider"></div>

## Python Syntax Highlighting

Automatic language detection based on file extension:

<div class="usage-code">
{% raw %}{% github_code pallets/flask/blob/main/src/flask/__init__.py#L1-L20 %}{% endraw %}
</div>

{% github_code pallets/flask/blob/main/src/flask/__init__.py#L1-L20 %}

<div class="divider"></div>

## Using Full GitHub URLs

You can also use complete GitHub URLs:

<div class="usage-code">
{% raw %}{% github_code https://github.com/r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile#L1-L5 %}{% endraw %}
</div>

{% github_code https://github.com/r0x0d/toolbox-dev/blob/main/toolbox/environment/fedora-packaging.Containerfile#L1-L5 %}

