Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB807466BF1
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 23:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhLBWMl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 17:12:41 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39266 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhLBWMl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 17:12:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9C438CE215D;
        Thu,  2 Dec 2021 22:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E7AC00446;
        Thu,  2 Dec 2021 22:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638482954;
        bh=0IMsyoYmKCzaxAw2IYE++tCz/Vk3uXLAO4VbsqvW0yU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l5d/tCXhYu8PJh+MarBaDBIR2rTSn+Ty8G0eqKsba+/8GsQ5xODTBFamWNpAGf55z
         wSuwMV0JZ4XWDc5Hhla3Ke/zJakl+Axcbc91A7VmQ+FY3cZ1TyJKt5aJorD/Yx4Wvi
         Oe7//wyZC6WlDSmSjyIatoNp6FmNtCV/cg+91lsVaU8G+CZBheQtCxXvKYT/P2RBYb
         uBraeQALtm+4yHFi6OvLW9HgEib+RAKrNss5OSOzttwI2SafmmjkVj5h97yqwxY5Ou
         PYrUL6aXgRg0RkZvjy/0jeFiFU1cvpMp9PnsUH4pzrWc6+IhK7ZqlwmZUvu2jBDywX
         dsVv0gXSlcZeQ==
Date:   Thu, 2 Dec 2021 14:09:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/5] fsverity: update the documentation
Message-ID: <YalECRGeo2OmDnkV@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-6-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202215507.298415-6-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 02, 2021 at 04:55:07PM -0500, Mimi Zohar wrote:
> Update the fsverity documentation related to IMA signature support.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>  Documentation/filesystems/fsverity.rst | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
> index 1d831e3cbcb3..c71f6e365df5 100644
> --- a/Documentation/filesystems/fsverity.rst
> +++ b/Documentation/filesystems/fsverity.rst
> @@ -74,8 +74,12 @@ authenticating the files is up to userspace.  However, to meet some
>  users' needs, fs-verity optionally supports a simple signature
>  verification mechanism where users can configure the kernel to require
>  that all fs-verity files be signed by a key loaded into a keyring; see
> -`Built-in signature verification`_.  Support for fs-verity file hashes
> -in IMA (Integrity Measurement Architecture) policies is also planned.
> +`Built-in signature verification`_.
> +
> +IMA (Integrity Measurement Architecture) supports fs-verity file
> +digests based signatures stored as security.ima xattrs, which are
> +identified by the signature type IMA_VERITY_DIGSIG.
> +
>  
>  User API
>  ========
> @@ -653,13 +657,13 @@ weren't already directly answered in other parts of this document.
>      hashed and what to do with those hashes, such as log them,
>      authenticate them, or add them to a measurement list.
>  
> -    IMA is planned to support the fs-verity hashing mechanism as an
> -    alternative to doing full file hashes, for people who want the
> -    performance and security benefits of the Merkle tree based hash.
> -    But it doesn't make sense to force all uses of fs-verity to be
> -    through IMA.  As a standalone filesystem feature, fs-verity
> -    already meets many users' needs, and it's testable like other
> -    filesystem features e.g. with xfstests.
> +    IMA supports the fs-verity hashing mechanism as an alternative
> +    to doing full file hashes, for people who want the performance
> +    and security benefits of the Merkle tree based hash.  But it
> +    doesn't make sense to force all uses of fs-verity to be through
> +    IMA.  As a standalone filesystem feature, fs-verity already meets
> +    many users' needs, and it's testable like other filesystem
> +    features e.g. with xfstests.
>  

Isn't there IMA documentation that can be linked to?

- Eric
