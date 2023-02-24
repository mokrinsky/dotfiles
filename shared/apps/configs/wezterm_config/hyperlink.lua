return {
  {
    regex = [[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}]],
    format = 'http://$0',
  },
  {
    regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
    format = '$0',
  },
  {
    regex = [[\bfile://\S*\b]],
    format = '$0',
  },
  {
    regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
    format = '$0',
  },
}
