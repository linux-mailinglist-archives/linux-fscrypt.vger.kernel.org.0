Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3A42CEE3
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Oct 2021 00:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhJMW4g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 13 Oct 2021 18:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbhJMW4f (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 13 Oct 2021 18:56:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E68C061570;
        Wed, 13 Oct 2021 15:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=DsH9WcMVyggggsdQx3bujMapUdnlUoCWn8obGz9Evmg=; b=GUGQh00o6vm3mO8uquvBObd9k9
        xig3DOa/oIupOI44S2XFrwQSfegbECOQ6MKl7rK9p32qB6d9mttvm4bECkIyO9Apb16anxPPnCQTF
        BIiIdsU8F11eb0+F6EUQcI1mCPZMckQtjmedLAAJi38DWx8ci7qKe4AWQZrZ6vsu6J7OygfgR/WGR
        BLz/wjUInJEHPfBYDOaVFvkaRjbpAcIXEM206gIfwoJr7rUKXF6IOGoVIriYNTHaYVEyRDnl8iZjZ
        lEAbH+ivxLghmvukFqSpixPR5QGqI06jfHR3yLujF3AYmbo4YHFoOzCiq6uAZJosRMDrENx+jtzwx
        9Ln/7dDA==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1man8o-000wgr-2f; Wed, 13 Oct 2021 22:54:30 +0000
Subject: Re: [RFC PATCH v7 07/16] ipe: add auditing support
To:     deven.desai@linux.microsoft.com, corbet@lwn.net, axboe@kernel.dk,
        agk@redhat.com, snitzer@redhat.com, ebiggers@kernel.org,
        tytso@mit.edu, paul@paul-moore.com, eparis@redhat.com,
        jmorris@namei.org, serge@hallyn.com
Cc:     jannh@google.com, dm-devel@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-audit@redhat.com,
        linux-security-module@vger.kernel.org
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <9c1eec3b-8bb0-9e3e-d6e5-18c670ac2b03@infradead.org>
Date:   Wed, 13 Oct 2021 15:54:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1634151995-16266-8-git-send-email-deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

On 10/13/21 12:06 PM, deven.desai@linux.microsoft.com wrote:
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> index c4503083e92d..ef556b66e674 100644
> --- a/security/ipe/Kconfig
> +++ b/security/ipe/Kconfig
> @@ -17,3 +17,55 @@ menuconfig SECURITY_IPE
>   	  requirements on the fly.
>   
>   	  If unsure, answer N.
> +
> +if SECURITY_IPE
> +
> +choice
> +	prompt "Hash algorithm used in auditing policies"
> +	default IPE_AUDIT_HASH_SHA1
> +	depends on AUDIT
> +	help
> +		Specify the hash algorithm used when auditing policies.
> +		The hash is used to uniquely identify a policy from other
> +		policies on the system.
> +
> +		If unsure, leave default.
> +
> +	config IPE_AUDIT_HASH_SHA1
> +		bool "sha1"
> +		depends on CRYPTO_SHA1
> +		help
> +			Use the SHA128 algorithm to hash policies
> +			in the audit records.
> +
> +	config IPE_AUDIT_HASH_SHA256
> +		bool "sha256"
> +		depends on CRYPTO_SHA256
> +		help
> +			Use the SHA256 algorithm to hash policies
> +			in the audit records.
> +
> +	config IPE_AUDIT_HASH_SHA384
> +		bool "sha384"
> +		depends on CRYPTO_SHA512
> +		help
> +			Use the SHA384 algorithm to hash policies
> +			in the audit records
> +
> +	config IPE_AUDIT_HASH_SHA512
> +		bool "sha512"
> +		depends on CRYPTO_SHA512
> +		help
> +			Use the SHA512 algorithm to hash policies
> +			in the audit records
> +endchoice
> +
> +config IPE_AUDIT_HASH_ALG
> +	string
> +	depends on AUDIT
> +	default "sha1" if IPE_AUDIT_HASH_SHA1
> +	default "sha256" if IPE_AUDIT_HASH_SHA256
> +	default "sha384" if IPE_AUDIT_HASH_SHA384
> +	default "sha512" if IPE_AUDIT_HASH_SHA512
> +
> +endif

Please follow coding-style for Kconfig files:

(from Documentation/process/coding-style.rst, section 10):

For all of the Kconfig* configuration files throughout the source tree,
the indentation is somewhat different.  Lines under a ``config`` definition
are indented with one tab, while help text is indented an additional two
spaces.


thanks.
-- 
~Randy
