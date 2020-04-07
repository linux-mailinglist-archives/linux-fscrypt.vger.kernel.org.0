Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB711A0619
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Apr 2020 07:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgDGFKq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Apr 2020 01:10:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgDGFKq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Apr 2020 01:10:46 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3F1C206F7;
        Tue,  7 Apr 2020 05:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586236246;
        bh=LrP4qK/nKXJou4CrEHzskTPTyVibkrMcNhchAtVAB8s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8MCAp4TEd0MlYgVplDrrq+E/pcMFFb8u2O54OnF0gqVxEsIqQ2FdXSX89ipHlGqL
         RtyvWJVYkaP4vSH44kth8LGTjxwXY1lTANUaNZN0tlX7SpGYGcs0j5czUQZe6nyxUe
         zuXYuRINreX7ufgKcMYfgkTo+VEtdMAyzIN17Jvc=
Date:   Mon, 6 Apr 2020 22:10:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 4/4] tune2fs.8: document the stable_inodes feature
Message-ID: <20200407051044.GB102437@sol.localdomain>
References: <20200401203239.163679-1-ebiggers@kernel.org>
 <20200401203239.163679-5-ebiggers@kernel.org>
 <0AB7921E-98F6-430C-87BB-63D1330885CE@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0AB7921E-98F6-430C-87BB-63D1330885CE@dilger.ca>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Apr 01, 2020 at 08:12:14PM -0600, Andreas Dilger wrote:
> On Apr 1, 2020, at 2:32 PM, Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> IMHO, it would be better if the updates to the man pages were in the same
> patch as the patch to misc/tune2fs.c.
> 
> That said, it's better than *not* getting an update to the man page, so:
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> 

Well, I should have included a man page update when adding '-O stable_inodes'
originally several months ago.  But now it's just being updated, and it makes
more sense to have separate patches for fixes and new documentation.

- Eric
