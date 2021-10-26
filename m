Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574EA43B4EF
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Oct 2021 16:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbhJZO7A (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Oct 2021 10:59:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47072 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhJZO67 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Oct 2021 10:58:59 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id CDEC921940;
        Tue, 26 Oct 2021 14:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635260194;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iLlATv0+IgKHTxqgZRY9J99BYRRxI/4+lGy7EuUNXE8=;
        b=DACfyd4qTAfe2+WittN7dKsl/Y8Ss0Eu4WeNV4YtAo7MAOlHGong6aLu77+6RVxCYl3gOh
        bd2crrscW5nmjXWhDdLHkPHjGrt7KkBhDzpt9JxHfyuZFVIYB6hISjKabSuxYUr+1I7JOa
        rK4AQDU8fVqQ8jRft8HJq6AKa0I7fbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635260194;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iLlATv0+IgKHTxqgZRY9J99BYRRxI/4+lGy7EuUNXE8=;
        b=QPwuPGM8L7r8cUi6KcQp5frmsIUS5J2/g/y+zbuZ95l1YtkRZTakytamF2THZPr6vH7k7M
        V8GuyftEQ4iKJBDQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id BD9EAA3B83;
        Tue, 26 Oct 2021 14:56:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4149DDA7A9; Tue, 26 Oct 2021 16:56:03 +0200 (CEST)
Date:   Tue, 26 Oct 2021 16:56:03 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@fb.com
Subject: Re: Btrfs Fscrypt Design Document
Message-ID: <20211026145603.GU20319@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Eric Biggers <ebiggers@kernel.org>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@fb.com
References: <YXGyq+buM79A1S0L@relinquished.localdomain>
 <YXcKX3iNmqlGsdzv@gmail.com>
 <YXez9Yq9ygfjKhoz@relinquished.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXez9Yq9ygfjKhoz@relinquished.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 26, 2021 at 12:53:25AM -0700, Omar Sandoval wrote:
> On Mon, Oct 25, 2021 at 12:49:51PM -0700, Eric Biggers wrote:
> > On Thu, Oct 21, 2021 at 11:34:19AM -0700, Omar Sandoval wrote:
> > Now, I personally think that authenticating file contents only wouldn't give
> > much benefit, and whole-filesystem authentication would be needed to get a real
> > benefit.  But "why aren't you using an authenticated mode" is a *very* common
> > question, so you need an answer to that -- or ideally, just support it if it
> > isn't much work.
> 
> We already store a checksum per block; I don't see any reason that it
> couldn't be a MAC. Johannes Thumshirn had a proof of concept for storing
> an HMAC for all blocks:
> https://lore.kernel.org/linux-btrfs/20191015121405.19066-1-jthumshirn@suse.de/#b
> Plumbing it through for authenticated encryption would be a little
> harder, but probably not by much.

I've been working on the HMAC as checksums and still want to finish as
time permits, so if you have any potential changes beyond "hmac is just
another checksum", please let me know.
