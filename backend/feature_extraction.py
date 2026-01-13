from urllib.parse import urlparse
import re


def extract_features(url):
    """
    Extract exactly 48 features from URL for phishing detection
    Each feature is carefully calculated - NO PLACEHOLDERS!
    """
    features = []
    parsed = urlparse(url)

    # Safe extraction of URL components
    domain = parsed.hostname if parsed.hostname else ""
    path = parsed.path if parsed.path else ""
    query = parsed.query if parsed.query else ""

    # Feature 1: NumDots
    features.append(url.count("."))

    # Feature 2: SubdomainLevel
    if domain:
        subdomain_parts = domain.split(".")
        features.append(len(subdomain_parts) - 2 if len(subdomain_parts) > 2 else 0)
    else:
        features.append(0)

    # Feature 3: PathLevel
    path_parts = [p for p in path.split("/") if p]
    features.append(len(path_parts))

    # Feature 4: UrlLength
    features.append(len(url))

    # Feature 5: NumDash
    features.append(url.count("-"))

    # Feature 6: NumDashInHostname
    features.append(domain.count("-"))

    # Feature 7: AtSymbol
    features.append(1 if "@" in url else 0)

    # Feature 8: TildeSymbol
    features.append(1 if "~" in url else 0)

    # Feature 9: NumUnderscore
    features.append(url.count("_"))

    # Feature 10: NumPercent
    features.append(url.count("%"))

    # Feature 11: NumQueryComponents
    query_parts = [q for q in query.split("&") if q]
    features.append(len(query_parts))

    # Feature 12: NumAmpersand
    features.append(url.count("&"))

    # Feature 13: NumHash
    features.append(url.count("#"))

    # Feature 14: NumNumericChars
    features.append(sum(c.isdigit() for c in url))

    # Feature 15: NoHttps
    features.append(0 if parsed.scheme == "https" else 1)

    # Feature 16: RandomString (sequences of 20+ random chars)
    features.append(1 if re.search(r"[a-zA-Z0-9]{20,}", url) else 0)

    # Feature 17: IpAddress
    ip_pattern = r"^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
    features.append(1 if re.match(ip_pattern, domain) else 0)

    # Feature 18: DomainInSubdomains (suspicious keywords in subdomain)
    suspicious_keywords = [
        "login",
        "signin",
        "account",
        "verify",
        "secure",
        "update",
        "banking",
    ]
    domain_lower = domain.lower()
    features.append(1 if any(kw in domain_lower for kw in suspicious_keywords) else 0)

    # Feature 19: DomainInPaths (suspicious keywords in path)
    path_lower = path.lower()
    features.append(1 if any(kw in path_lower for kw in suspicious_keywords) else 0)

    # Feature 20: HttpsInHostname
    features.append(1 if "https" in domain_lower else 0)

    # Feature 21: HostnameLength
    features.append(len(domain))

    # Feature 22: PathLength
    features.append(len(path))

    # Feature 23: QueryLength
    features.append(len(query))

    # Feature 24: DoubleSlashInPath
    features.append(1 if "//" in path else 0)

    # Feature 25: NumSensitiveWords
    sensitive_words = [
        "secure",
        "account",
        "update",
        "login",
        "signin",
        "banking",
        "confirm",
        "verify",
        "password",
        "suspend",
    ]
    url_lower = url.lower()
    features.append(sum(1 for word in sensitive_words if word in url_lower))

    # Feature 26: DigitRatioInDomain
    features.append(
        sum(c.isdigit() for c in domain) / len(domain) if len(domain) > 0 else 0
    )

    # Feature 27: AlphaRatioInDomain
    features.append(
        sum(c.isalpha() for c in domain) / len(domain) if len(domain) > 0 else 0
    )

    # Feature 28: DotRatioInURL
    features.append(url.count(".") / len(url) if len(url) > 0 else 0)

    # Feature 29: DashRatioInDomain
    features.append(domain.count("-") / len(domain) if len(domain) > 0 else 0)

    # Feature 30: SpecialCharRatioInURL
    special_chars = sum(1 for c in url if not c.isalnum() and c not in [":", "/", "."])
    features.append(special_chars / len(url) if len(url) > 0 else 0)

    # Feature 31: SuspiciousTLD
    suspicious_tlds = [
        ".tk",
        ".ml",
        ".ga",
        ".cf",
        ".gq",
        ".xyz",
        ".top",
        ".work",
        ".click",
        ".info",
    ]
    features.append(
        1 if any(url.lower().endswith(tld) for tld in suspicious_tlds) else 0
    )

    # Feature 32: ShortDomain
    domain_name = domain.split(".")[0] if "." in domain else domain
    features.append(1 if len(domain_name) < 5 else 0)

    # Feature 33: PortNumber
    features.append(1 if parsed.port else 0)

    # Feature 34: MultipleWWW
    features.append(1 if url.lower().count("www") > 1 else 0)

    # Feature 35: IPAddressInURL
    features.append(1 if re.search(r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}", url) else 0)

    # Feature 36: NumberOfSubdomains
    domain_parts = domain.split(".")
    features.append(len(domain_parts) if len(domain_parts) > 0 else 0)

    # Feature 37: MultipleHTTP
    features.append(1 if url.lower().count("http") > 1 else 0)

    # Feature 38: QuestionMarkCount
    features.append(url.count("?"))

    # Feature 39: EqualsSignCount
    features.append(url.count("="))

    # Feature 40: WWWCount
    features.append(url.lower().count("www"))

    # Feature 41: TLDLength
    tld = domain.split(".")[-1] if "." in domain else ""
    features.append(len(tld))

    # Feature 42: VeryLongDomain
    features.append(1 if len(domain) > 30 else 0)

    # Feature 43: FrequencyOfCOM
    features.append(url.lower().count("com"))

    # Feature 44: FrequencyOfNET
    features.append(url.lower().count("net"))

    # Feature 45: BracketsPresent
    features.append(1 if any(c in url for c in ["[", "]", "{", "}"]) else 0)

    # Feature 46: NonASCIIChars
    features.append(sum(1 for c in url if ord(c) > 127))

    # Feature 47: UppercaseSequence
    features.append(1 if re.search(r"[A-Z]{5,}", url) else 0)

    # Feature 48: NumberOfDigitGroups
    digit_groups = re.findall(r"\d+", url)
    features.append(len(digit_groups))

    # Verify exactly 48 features
    if len(features) != 48:
        print(f"WARNING: Expected 48 features but got {len(features)}")
        # Pad or truncate to exactly 48
        while len(features) < 48:
            features.append(0)
        features = features[:48]

    return features
