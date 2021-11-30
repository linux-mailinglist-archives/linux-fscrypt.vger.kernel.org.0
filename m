Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F23D462A85
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 03:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237590AbhK3CgZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 21:36:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44644 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbhK3CgZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 21:36:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12C7DB816C5;
        Tue, 30 Nov 2021 02:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D7EC53FC7;
        Tue, 30 Nov 2021 02:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638239584;
        bh=6dK1A1KLQrmLHmky6JoKWhl4u7mQlEeB1XsXSSDqfpo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WK3ASy8TVV/NKFCNde2/l4BbaNFeYRuC6Q0XPLy1odYwZWLNat7Fnx1yl6eRYB5Ak
         T6BEId/YVS0sCHUFI8YX+OFeYRvgvM7Bl48Q16/AFyxldokqfS8DVOSkQhjOUzLsv8
         V9mPBC61MjZw4vqSxkrbkOlqT/HSP7+SY83wYN6WLlqRO4CyiEiMWYWfR7kjo+jH6b
         YLWVRYgEsL4SpYx5B6h5bCnaJp6npiLN16GVykZ00pdHmhIEfvTAjtJDVsFzF3Hos6
         T9GlKu6opbQIlsOLCKrMNhF2V5PWixGhrbvpm5yf3U9PH6s+VpNMYJZOx2u+9IhAIM
         m/I8lI9U0jUKA==
Date:   Mon, 29 Nov 2021 18:33:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ima: define a new signature type named
 IMA_VERITY_DIGSIG
Message-ID: <YaWNX3nwslG/Q2aH@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
 <20211129170057.243127-3-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129170057.243127-3-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 29, 2021 at 12:00:55PM -0500, Mimi Zohar wrote:
> To differentiate between a regular file hash and an fs-verity file digest
> based signature stored as security.ima xattr, define a new signature type
> named IMA_VERITY_DIGSIG.
> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>

For this new signature type, what bytes are actually signed?  It looks like it's
just the raw digest, which isn't sufficient since it is ambiguous.  It needs to
include information that makes it clear what the signer is actually signing,
such as "this is an fs-verity SHA-256 file digest".  See
'struct fsverity_formatted_digest' for an example of this (but it isn't
necessary to use that exact structure).

I think the existing IMA signatures have the same problem (but it is hard for me
to understand the code).  However, a new signature type doesn't have
backwards-compatibility concerns, so it could be done right.

- Eric
