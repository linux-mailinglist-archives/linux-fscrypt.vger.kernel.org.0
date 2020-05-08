Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C511CA134
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 May 2020 04:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgEHCzp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 22:55:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:41262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726701AbgEHCzp (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 22:55:45 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E329520731;
        Fri,  8 May 2020 02:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588906545;
        bh=xZL6GABrc5V8zEN+WNgdg5AUydrKLRFO8szbem4wjEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YzgJmsRpYUp92OBc8zIyiikyOWIf9biXSi+7O9rdRZskko9YnlEa+BbnHrggIb4eB
         YG2+OQSPa2znUdsigdgsWMvC2sHrVsKj7+DpRhHCYJwA2Um3cNfJUx6mCawYmBZo3X
         Vc/5HHm/xaYQkfhs63iNsG7f0KMRxiFS7kmNV0hU=
Date:   Thu, 7 May 2020 19:55:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-fscrypt@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Subject: Re: [RFC PATCH 4/4] f2fs: Handle casefolding with Encryption
 (INCOMPLETE)
Message-ID: <20200508025543.GA63151@sol.localdomain>
References: <20200507075905.953777-1-ebiggers@kernel.org>
 <20200507075905.953777-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507075905.953777-5-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 07, 2020 at 12:59:05AM -0700, Eric Biggers wrote:
> -static void init_dent_inode(const struct f2fs_filename *fname,
> +static void init_dent_inode(struct inode *dir, struct inode *inode,
> +			    const struct f2fs_filename *fname,
>  			    struct page *ipage)
>  {
>  	struct f2fs_inode *ri;
>  
> +	if (!fname) /* tmpfile case? */
> +		return;
> +
>  	f2fs_wait_on_page_writeback(ipage, NODE, true, true);
>  
>  	/* copy name info. to this inode page */
>  	ri = F2FS_INODE(ipage);
>  	ri->i_namelen = cpu_to_le32(fname->disk_name.len);
>  	memcpy(ri->i_name, fname->disk_name.name, fname->disk_name.len);
> +	if (IS_ENCRYPTED(dir)) {
> +		file_set_enc_name(inode);
> +		/*
> +		 * Roll-forward recovery doesn't have encryption keys available,
> +		 * so it can't compute the dirhash for encrypted+casefolded
> +		 * filenames.  Append it to i_name if possible.  Else, disable
> +		 * roll-forward recovery of the dentry (i.e., make fsync'ing the
> +		 * file force a checkpoint) by setting LOST_PINO.
> +		 */
> +		if (IS_CASEFOLDED(dir)) {
> +			if (fname->disk_name.len + sizeof(f2fs_hash_t) <=
> +			    F2FS_NAME_LEN)
> +				put_unaligned(fname->hash,
> +					&ri->i_name[fname->disk_name.len]);

Jaegeuk pointed out that we need a cast to 'f2fs_hash_t *' here.

- Eric
