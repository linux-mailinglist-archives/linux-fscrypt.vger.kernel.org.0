Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5E41DC0D9
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 23:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgETVDi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 17:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbgETVDh (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 17:03:37 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44A2420829;
        Wed, 20 May 2020 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590008617;
        bh=8XiClLyIx0wIfXUHX48ZuP9L9i934wI9538Q8hBJZb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zlry/PdCehAgox/CwakcTtM/vSy6zP+XzXtt7pm0A8kZKLw+dkemzTFagTvvCKVNl
         g8m338xOfxRbWqxBy8NHxywyJr6aVYMQvyHQ+lTCtvXltws3e2o9iZe8NqwCnZFk2/
         VzU3rhTxNcuOQ0LUjFpRv8TXpB/arFt7nR9BwNKI=
Date:   Wed, 20 May 2020 14:03:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH v2 0/2] fsverity-utils Makefile fixes
Message-ID: <20200520210335.GA218475@gmail.com>
References: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 20, 2020 at 04:08:09PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Hi
> 
> This addresses the comments to the previous version of these Makefile
> changes.
> 
> Let me know if you have any additional issues with it?
> 
> I'd really love to see an official release soon that includes these
> changes, which I can point to when submitting the RPM patches. Any
> chance of doing 1.1 or something like that?
> 
> Cheers,
> Jes

I'll release v1.1 after I merge the libfsverity patches, but I need to look over
everything again first before committing to a stable API.  I'll try to get to it
this weekend; I'm also busy with a lot of other things.

Also, could you look over my patches and leave your Reviewed-by?  I expected
that you'd have a few more comments.

- Eric
