k logs serverweb -n meusite ou k logs -n meusite --selector=app=ovo

k get svc -o=jsonpath='{range .items[*]}{.metadata.name}:{"\t"}{.spec.selector}{"\n"}{end}'; echo