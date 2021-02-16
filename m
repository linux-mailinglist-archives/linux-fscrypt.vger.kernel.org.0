Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5439331D0EC
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Feb 2021 20:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhBPTXs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 16 Feb 2021 14:23:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45522 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229874AbhBPTXr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 16 Feb 2021 14:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613503340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4pWSLRXaDUWlGfbtpTYLoNYM1x810+cZzTTeKPfylQ=;
        b=bHS4lR6iaDr+OqlPA9sCzJTTt1wUkgbKZDo8BgWr/HufswiPSmMhoRdHaJG8wLUYLSZJBF
        t5VJ69sL9/pi6c7xO+FJGlSSyGZWj2Pa9tmkQuBeUC7eAddpjb5eKJnJprns0RvyOgq+yt
        epg2/k7JpY2PH2l3DOibcxcajndJc7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-b_2d1WJvMAGgXD8Ezp3O2g-1; Tue, 16 Feb 2021 14:22:18 -0500
X-MC-Unique: b_2d1WJvMAGgXD8Ezp3O2g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93E1480402E;
        Tue, 16 Feb 2021 19:22:17 +0000 (UTC)
Received: from ovpn-113-105.phx2.redhat.com (ovpn-113-105.phx2.redhat.com [10.3.113.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CB0819D6C;
        Tue, 16 Feb 2021 19:22:17 +0000 (UTC)
Message-ID: <3d0bb46eb1791899475722bd27ee3826853a5027.camel@redhat.com>
Subject: Re: fscrypt and FIPS
From:   Simo Sorce <simo@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Thibaud Ecarot <thibaud.ecarot@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        linux-fscrypt <linux-fscrypt@vger.kernel.org>
Date:   Tue, 16 Feb 2021 14:22:15 -0500
In-Reply-To: <YCwXSwseAoMdkXGG@gmail.com>
References: <c311c77131d0b146f00ab000104bd38e6fbc6b94.camel@redhat.com>
         <YCQcj0jQ5/sywDgT@sol.localdomain>
         <7fa8fc3ac6e15015df1ce5f3213e9901d98ffedd.camel@redhat.com>
         <CA+XEK3nU1jPHJ=FsJf+0rZ=KkNuuGZvo7WeBSpXUu3ytuFQEvw@mail.gmail.com>
         <45359a0121a3cb20dbdf217a1e96bd7263610913.camel@redhat.com>
         <29e4defba658cae99faccef451d7873b4cc056d9.camel@redhat.com>
         <YCwXSwseAoMdkXGG@gmail.com>
Organization: Red Hat, Inc.
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2021-02-16 at 11:04 -0800, Eric Biggers wrote:
> On Tue, Feb 16, 2021 at 12:47:05PM -0500, Simo Sorce wrote:
> > Some more info, sorry for the delay.
> > 
> > Currently, as epxlained eralier, the HKDF is approved only in specific
> > cases (from SP.800-56C rev 2), which is why I asked Jeff to inquire if
> > KDF agility was possible for fscrypt.
> > 
> > That said, we are also trying to get NIST to approve HKDF for use in
> > SP800-133 covered scenarios (Symmetric Keys Derived from Pre-Existing
> > Key), which is the case applicable to fscrypt (afaict).
> > 
> > SP.800-133 currently only allows KDFs as defined in SP.800-108, but
> > there is hope that SP.800-56C rev 2 KDFs can be alloed also, after all
> > they are already allowed for key-agreement schemes.
> > 
> > Hope this clears a bit why we inquired, it is just in case, for
> > whatever reason, NIST decided not to approve or delays a decision; to
> > be clear, there is nothing wrong in HKDF itself that we know of.
> > 
> 
> Just getting HKDF properly approved seems like a much better approach than doing
> a lot of work for nothing.  Not just for fscrypt but also for everything else
> using HKDF.

Yes, this would be the ideal outcome!
But I have to figure out the "what if" too ..

> - Eric
> 

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




