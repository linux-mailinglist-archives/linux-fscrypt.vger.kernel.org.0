Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C474528524A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Oct 2020 21:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgJFTT4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 6 Oct 2020 15:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgJFTT4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 6 Oct 2020 15:19:56 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C248206B5;
        Tue,  6 Oct 2020 19:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602011995;
        bh=ov/h1Xqg0UOCJfEEBRiRrL5VVBUq6at/su2wB3rWscM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mv5ki+7+ByDNKqS4mIXj0C7OTINtnjK0tQS7WQEfhuUfGHOz+yn0F1TlQ1dJtBVea
         Wh4KnR0E5VZKb2rHxtjQXSP/mnp7LAu6u2upjfVcO6k2bhJ0+bfifkCRUKcx3LzHmj
         BMpoDxNUlmGjtOGePIZnuAT/Q62E7pN62cuc1V9Q=
Date:   Tue, 6 Oct 2020 12:19:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 35/52] docs: fs: fscrypt.rst: get rid of :c:type: tags
Message-ID: <20201006191953.GA3598358@gmail.com>
References: <cover.1601992016.git.mchehab+huawei@kernel.org>
 <81cd5da550e06de8e85dcadef4909ff5f1d23319.1601992016.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81cd5da550e06de8e85dcadef4909ff5f1d23319.1601992016.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 06, 2020 at 04:03:32PM +0200, Mauro Carvalho Chehab wrote:
> The :c:type: tag has problems with Sphinx 3.x, as structs
> there should be declared with c:struct.
> 
> So, remove them, relying at automarkup.py extension to
> convert them into cross-references.

I tried 'make htmldocs' before and after your patchset ("sphinx3-fixes-v5").
Before, all the struct fscrypt_* are rendered in code font.  After, they are
rendered in the regular text font.  Is that really working as intended?

> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/filesystems/fscrypt.rst | 51 ++++++++++++---------------
>  1 file changed, 23 insertions(+), 28 deletions(-)
> 

Why are the changes to fscrypt.rst split between two patches,

	docs: get rid of :c:type explicit declarations for structs

and

	docs: fs: fscrypt.rst: get rid of :c:type: tags

?  They're the same type of changes.  The first just removes half the :c:type:
tags, and the second removes the rest.  Shouldn't it be one patch?

> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 4f858b38a412..46a9d1bd2ab5 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -437,8 +437,7 @@ FS_IOC_SET_ENCRYPTION_POLICY
>  The FS_IOC_SET_ENCRYPTION_POLICY ioctl sets an encryption policy on an
>  empty directory or verifies that a directory or regular file already
>  has the specified encryption policy.  It takes in a pointer to a
> -struct fscrypt_policy_v1 or a :c:type:`struct
> -fscrypt_policy_v2`, defined as follows::
> +struct fscrypt_policy_v1 or a struct fscrypt_policy_v2, defined as follows::
[...]
>  If the file is not yet encrypted, then FS_IOC_SET_ENCRYPTION_POLICY
>  verifies that the file is an empty directory.  If so, the specified
> @@ -637,9 +634,8 @@ The FS_IOC_GET_ENCRYPTION_POLICY ioctl can also retrieve the
>  encryption policy, if any, for a directory or regular file.  However,
>  unlike `FS_IOC_GET_ENCRYPTION_POLICY_EX`_,
>  FS_IOC_GET_ENCRYPTION_POLICY only supports the original policy
> -version.  It takes in a pointer directly to a :c:type:`struct
> -fscrypt_policy_v1` rather than a :c:type:`struct
> -fscrypt_get_policy_ex_arg`.
> +version.  It takes in a pointer directly to struct fscrypt_policy_v1
> +rather than struct fscrypt_get_policy_ex_arg.

In some cases you deleted the "a" in "a struct" but in other cases you didn't.
Intentional?  It seems the file should consistently use one style or the other.

Also please use textwidth=70 for consistency with the rest of the file.

- Eric
