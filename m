Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83C6140F6A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Jan 2020 17:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgAQQ41 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 17 Jan 2020 11:56:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726559AbgAQQ41 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 17 Jan 2020 11:56:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE81C2072B;
        Fri, 17 Jan 2020 16:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579280186;
        bh=itV4GZdAwjB8Lf2mvaZRf7Z5T2MikjbR+tHNgH8x7Ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eH5zxBHyWnHhM0fzuTtFItQX3h3ARLC8wvey/8gEsSn1hob0N06+kjPORG7OY14De
         QrJjZUhJyLqvlTzk7np+QfUA6dQP7Pgw5pF504M0eQqDOensC73sgpHjdgT0iomyQb
         Ympq5BXzPJhTWLd5/oAA3cB4qYuWz4YWHFNxeD3Q=
Date:   Fri, 17 Jan 2020 17:56:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH] fscrypt: reserve flags for hardware-wrapped keys feature
Message-ID: <20200117165624.GC1937954@kroah.com>
References: <20200116192008.35766-1-ebiggers@kernel.org>
 <20200117081246.GA16846@infradead.org>
 <20200117164054.GD448999@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117164054.GD448999@mit.edu>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jan 17, 2020 at 11:40:54AM -0500, Theodore Y. Ts'o wrote:
> On Fri, Jan 17, 2020 at 12:12:46AM -0800, Christoph Hellwig wrote:
> > On Thu, Jan 16, 2020 at 11:20:08AM -0800, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > Reserve flags for the hardware-wrapped keys feature which is being
> > > worked on [1].  FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY will denote that the
> > > encryption policy needs a hardware-wrapped key to be unlocked.
> > > FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED will denote that the key being added is
> > > a hardware-wrapped key.
> > > 
> > > This reservation is tentative, and these codepoints may be reused if the
> > > feature is not upstreamed.
> > 
> > NAK.  While the feature itself sounds really useful we don't just
> > reserve format bits for code not upstream.
> 
> I disagree; saving a codepoint to avoid accidental collision of a
> feature bit is a good and proper thing to do.
> 
> Reviewed-by: Theodore Ts'o <tytso@mit.edu>

What kind of "deadline" do you have for that feature to then be merged?
I'm with Christoph here, we shouldn't be reserving bits for stuff not
in mergable state, what's the rush?

thansk,

greg k-h
