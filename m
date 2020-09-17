Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F5B26E0CB
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Sep 2020 18:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728569AbgIQQdp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Sep 2020 12:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728369AbgIQQdd (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Sep 2020 12:33:33 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C27D2214D8;
        Thu, 17 Sep 2020 16:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600360408;
        bh=64guTUZ7EKPT2qpTc7D0yaFTflRcH4pcyFWo+xuAOGU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eU1pP6hgmXz25xyBg9bazb9fKAso0aXmNP2dVveMx2ztmBwOjVdBVik39B9/dsfyi
         l7B1BELQj4b0ud+U4UFntHF3lCMR/Rq5xrFwpLL3OBQuZckdLAshp7dwLe0wC59tkq
         GBid0tzn4y03cySN4r38Z/i9cVEe43zaJsX5UFUA=
Message-ID: <197468586b4a9b933755d2f9a462a234d654e280.camel@kernel.org>
Subject: Re: [PATCH v3 13/13] fscrypt: make
 fscrypt_set_test_dummy_encryption() take a 'const char *'
From:   Jeff Layton <jlayton@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org,
        Daniel Rosenberg <drosen@google.com>
Date:   Thu, 17 Sep 2020 12:33:26 -0400
In-Reply-To: <20200917152907.GB855@sol.localdomain>
References: <20200917041136.178600-1-ebiggers@kernel.org>
         <20200917041136.178600-14-ebiggers@kernel.org>
         <41ad3cd50f4d213455bef4e7c42143c289690222.camel@kernel.org>
         <20200917152907.GB855@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 2020-09-17 at 08:29 -0700, Eric Biggers wrote:
> On Thu, Sep 17, 2020 at 08:32:39AM -0400, Jeff Layton wrote:
> > On Wed, 2020-09-16 at 21:11 -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > > 
> > > fscrypt_set_test_dummy_encryption() requires that the optional argument
> > > to the test_dummy_encryption mount option be specified as a substring_t.
> > > That doesn't work well with filesystems that use the new mount API,
> > > since the new way of parsing mount options doesn't use substring_t.
> > > 
> > > Make it take the argument as a 'const char *' instead.
> > > 
> > > Instead of moving the match_strdup() into the callers in ext4 and f2fs,
> > > make them just use arg->from directly.  Since the pattern is
> > > "test_dummy_encryption=%s", the argument will be null-terminated.
> > > 
> > 
> > Are you sure about that? I thought the point of substring_t was to give
> > you a token from the string without null terminating it.
> > 
> > ISTM that when you just pass in ->from, you might end up with trailing
> > arguments in your string like this. e.g.:
> > 
> >     "v2,foo,bar,baz"
> > 
> > ...and then that might fail to match properly
> > in fscrypt_set_test_dummy_encryption.
> > 
> 
> Yes I'm sure, and I had also tested it.  The use of match_token() here is to
> parse one null-terminated mount option at a time.
> 
> The reason that match_token() can return multiple substrings is that the pattern
> might be something like "foo=%d:%d".
> 
> But here it's just "test_dummy_encryption=%s". "%s" matches until end-of-string.

Got it. Thanks for explaining!
-- 
Jeff Layton <jlayton@kernel.org>

