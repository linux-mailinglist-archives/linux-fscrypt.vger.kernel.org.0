Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870E927B80B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 29 Sep 2020 01:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgI1XZb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Sep 2020 19:25:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbgI1XZb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Sep 2020 19:25:31 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D59221EC;
        Mon, 28 Sep 2020 22:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601330784;
        bh=zTrp+AaZ5ZTVYHgi1Eia39EvvmmLN6MDy5gVqyiAGBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UPyrygl93Rl8LQS4KBdAKiMrJULfPXtGHBTZ3ZmoUxwfm/LbLPpKUs8Jvx+9Zdx1c
         QimJvhJkYN7V2SXFZrUTqhVPKl4eDKRujZoxg4kywpiatwfxt7kpwhFMIIeYvAMZg/
         POZL1P9KDAChUM9vKYc+bCYoKYlzQkG8dMdPHKJ4=
Date:   Mon, 28 Sep 2020 15:06:23 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Satya Tangirala <satyat@google.com>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [xfstests-bld PATCH v2] test-appliance: exclude generic/587 from
 the encrypt tests
Message-ID: <20200928220623.GE1340@sol.localdomain>
References: <20200709184145.GA3855682@gmail.com>
 <20200709185832.2568081-1-satyat@google.com>
 <20200709191031.GB3855682@gmail.com>
 <20200924172729.GI482521@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924172729.GI482521@mit.edu>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 24, 2020 at 01:27:29PM -0400, Theodore Y. Ts'o wrote:
> On Thu, Jul 09, 2020 at 12:10:31PM -0700, Eric Biggers wrote:
> > On Thu, Jul 09, 2020 at 06:58:32PM +0000, Satya Tangirala wrote:
> > > The encryption feature doesn't play well with quota, and generic/587
> > > tests quota functionality.
> > > 
> > > Signed-off-by: Satya Tangirala <satyat@google.com>
> > 
> > Reviewed-by: Eric Biggers <ebiggers@google.com>
> 
> Applied, thanks
> 

Thanks.  Looks like you forgot to push?  Also, the kernel.org and github
repositories for xfstests-bld aren't in sync.

- Eric
