Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128D61FA366
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Jun 2020 00:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgFOWWm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Jun 2020 18:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFOWWm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Jun 2020 18:22:42 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9116D20714;
        Mon, 15 Jun 2020 22:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592259761;
        bh=dEKEM9tfJcQh4c0Hq4LpP7QhlBxMRIlRi8fRHrmGiMA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yV101K4k+8nMYB0Hj90e2MhEqc9Xu+Ra/bdEaJZ0JS5P7F8G7xT21kYJ2SlAgD475
         j8kBgnWtwl7BmuuumVNCU3C7QzldqCW0/oFHvrchS+qR9y2yo7M1zZ/d8qkVnDtwCR
         s9DXnj1sWrjZWF906LLWq0j7/LKBXDZZ+z/pHWAA=
Date:   Mon, 15 Jun 2020 15:22:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/4] e2fsprogs: fix and document the stable_inodes feature
Message-ID: <20200615222240.GD85413@gmail.com>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200410152406.GO45598@mit.edu>
 <20200507181847.GD236103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507181847.GD236103@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 07, 2020 at 11:18:47AM -0700, Eric Biggers wrote:
> On Fri, Apr 10, 2020 at 11:24:06AM -0400, Theodore Y. Ts'o wrote:
> > On Wed, Apr 01, 2020 at 01:32:35PM -0700, Eric Biggers wrote:
> > > Fix tune2fs to not allow cases where IV_INO_LBLK_64-encrypted files
> > > (which can exist if the stable_inodes feature is set) could be broken:
> > > 
> > > - Changing the filesystem's UUID
> > > - Clearing the stable_inodes feature
> > > 
> > > Also document the stable_inodes feature in the appropriate places.
> > > 
> > > Eric Biggers (4):
> > >   tune2fs: prevent changing UUID of fs with stable_inodes feature
> > >   tune2fs: prevent stable_inodes feature from being cleared
> > >   ext4.5: document the stable_inodes feature
> > >   tune2fs.8: document the stable_inodes feature
> > 
> > Thanks, I've applied this patch series.
> > 
> 
> Ted, I still don't see this in git.  Are you planning to push it out?
> 

Ping?
