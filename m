Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8E51C9920
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 20:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727799AbgEGSSt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 14:18:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:58012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgEGSSt (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 14:18:49 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 958D92070B;
        Thu,  7 May 2020 18:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588875528;
        bh=ixJzGpMFc+8RM4fOcW9rDJd0xxmXQcnL4fbmu9/fspA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LLK9yTCXMk40WuTOzZEWzXqFxqz2iKJo15dti1Z6bpOLExM0CgixoJD7LiLyUxiKq
         Z1zUF+pM1uvoKtPCQLf2mAnw+pxqZUlm0BZbijniErU4Qp2Q4D/j/2kw/Khb1ALVTG
         Y/g13LEc/gbJcR+FA0Bx4ZL7jS+53M0puwVP21yY=
Date:   Thu, 7 May 2020 11:18:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/4] e2fsprogs: fix and document the stable_inodes feature
Message-ID: <20200507181847.GD236103@gmail.com>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200410152406.GO45598@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410152406.GO45598@mit.edu>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 10, 2020 at 11:24:06AM -0400, Theodore Y. Ts'o wrote:
> On Wed, Apr 01, 2020 at 01:32:35PM -0700, Eric Biggers wrote:
> > Fix tune2fs to not allow cases where IV_INO_LBLK_64-encrypted files
> > (which can exist if the stable_inodes feature is set) could be broken:
> > 
> > - Changing the filesystem's UUID
> > - Clearing the stable_inodes feature
> > 
> > Also document the stable_inodes feature in the appropriate places.
> > 
> > Eric Biggers (4):
> >   tune2fs: prevent changing UUID of fs with stable_inodes feature
> >   tune2fs: prevent stable_inodes feature from being cleared
> >   ext4.5: document the stable_inodes feature
> >   tune2fs.8: document the stable_inodes feature
> 
> Thanks, I've applied this patch series.
> 

Ted, I still don't see this in git.  Are you planning to push it out?

- Eric
