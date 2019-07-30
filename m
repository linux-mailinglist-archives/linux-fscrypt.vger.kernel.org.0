Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A6B79F95
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jul 2019 05:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfG3DrH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Jul 2019 23:47:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbfG3DrH (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Jul 2019 23:47:07 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39AF62087F;
        Tue, 30 Jul 2019 03:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564458426;
        bh=WRK35Z8spkNX0McemsZ/M7FJXHUe6FLiTAOOZjI0Yq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yabyUkn8u3MA8oejTuGyNquV2nDPgRy2UMAUZ1jBMlozA4EZlkYe/3xJLIi0GwutD
         8qNcZHA7pdsVVtO99OofNAqenq+Zxjk+Z5wbn1oa88ZNnVl+kjbLGERhqitdEtJIJR
         KM/U3/xuwtijwYnc06W5d7+Jcxp1H8SxgDw5c5UQ=
Date:   Mon, 29 Jul 2019 20:47:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
Subject: Re: linux-next: build warnings after merge of the keys tree
Message-ID: <20190730034704.GA1966@sol.localdomain>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Howells <dhowells@redhat.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org
References: <20190730123042.1f17cdd4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730123042.1f17cdd4@canb.auug.org.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 30, 2019 at 12:30:42PM +1000, Stephen Rothwell wrote:
> Subject: [PATCH] fsverity: merge fix for keyring_alloc API change
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/verity/signature.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/verity/signature.c b/fs/verity/signature.c
> index c8b255232de5..a7aac30c56ae 100644
> --- a/fs/verity/signature.c
> +++ b/fs/verity/signature.c
> @@ -131,15 +131,26 @@ static inline int __init fsverity_sysctl_init(void)
>  }
>  #endif /* !CONFIG_SYSCTL */
>  
> +static struct key_acl fsverity_acl = {
> +	.usage	= REFCOUNT_INIT(1),
> +	.possessor_viewable = true,

I don't think .possessor_viewable should be set here, since there's no
KEY_POSSESSOR_ACE(KEY_ACE_VIEW) in the ACL.  David, this bool is supposed to
mean such an entry is present, right?  Is it really necessary, since it's
redundant with the ACL itself?

> +	.nr_ace	= 2,
> +	.aces = {
> +		KEY_POSSESSOR_ACE(KEY_ACE_SEARCH | KEY_ACE_JOIN |
> +				  KEY_ACE_INVAL),
> +		KEY_OWNER_ACE(KEY_ACE_VIEW | KEY_ACE_READ | KEY_ACE_WRITE |
> +			      KEY_ACE_CLEAR | KEY_ACE_SEARCH |
> +			      KEY_ACE_SET_SECURITY | KEY_ACE_REVOKE),
> +	}
> +};
> +
>  int __init fsverity_init_signature(void)
>  {
>  	struct key *ring;
>  	int err;
>  
>  	ring = keyring_alloc(".fs-verity", KUIDT_INIT(0), KGIDT_INIT(0),
> -			     current_cred(), KEY_POS_SEARCH |
> -				KEY_USR_VIEW | KEY_USR_READ | KEY_USR_WRITE |
> -				KEY_USR_SEARCH | KEY_USR_SETATTR,
> +			     current_cred(), &fsverity_acl,
>  			     KEY_ALLOC_NOT_IN_QUOTA, NULL, NULL);

Otherwise this looks good, thanks Stephen.  I'll want to remove a few of these
permissions in a separate patch later, but for now we can just keep it
equivalent to the original code as you've done.

We'll have the same problem in fs/crypto/ in a week or two if/when I apply
another patch series.  For that one I'll send you a merge resolution so you
don't have to do it yourself...

Thanks,

- Eric
