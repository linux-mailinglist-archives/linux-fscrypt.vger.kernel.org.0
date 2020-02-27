Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA04D172A11
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Feb 2020 22:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbgB0VZT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Feb 2020 16:25:19 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36506 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgB0VZS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Feb 2020 16:25:18 -0500
Received: by mail-pj1-f68.google.com with SMTP id gv17so337281pjb.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 27 Feb 2020 13:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zbiMEvwdKM/tvZAA5Qj434C9S081Ob3tK31bpwxJweM=;
        b=PD5AuIH9YkPwMY1wk/M2YjcFyJ0ifFKkRpny5ZyGDYGn1QOO/zohITOuyJrm8SULUl
         7i+MnHC+yUTXTPi9Ej+G5yNVS3jFkcc7VmG08QcNrBd6venEz216NN4gW5ri9dfRMEY5
         T9q3N+SI14tw/2hmTyKa+XjXBZtxMwuu/SYW/t2qpCgLUResl8ne20dFgnF5Clkq+VPd
         fKd4zMbXTcBkWMq/t3v6ItovAlemxDo+YGgs9x//wHp14jvdIoTrJr8E7cFsndG+SFrU
         lQ3Su/cUXhsTRXyXiXcqdziWtx03q3ThazV8PbjImCgXZMy3x3k0A2xd3rU2TVHPaLCB
         3Adg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zbiMEvwdKM/tvZAA5Qj434C9S081Ob3tK31bpwxJweM=;
        b=h2DK8iHl6b9Z2s4vqS+0dbNqbCCWqk9jocsK0Z+k1ZqLlw0SFbIfe+9J2VtJMmorAX
         ycvdhuUa/qk40tRkuZuZyh2NB2Xew7CNJ5yWK4tTw+3B6i+gTHwNW+ge8qiLWJ6R+Mwd
         3eSlmoV6ykgGn897R0XCRhYn191OqQH/Ty/S6Fmz8KYSNr4wfu3jJCqNNSDbgRSn2NPg
         LzsxXIkQZmvalZO0TjJuCagI2LVee18m4kGjUGJ9v2jrIGsjVeB8EfFEGkJTn+M+TqVI
         +ZnEyI51nd08jK5Bj78Mhane7nkHo9b5EuW4HajfmqM8eMbs/PBOF1btSNbpbm63A7hB
         9XZQ==
X-Gm-Message-State: APjAAAVMhx0lcaP4mh4aI3m19qJEnnMQvnf+3yIUPxkBLDp171I33J5s
        ZY5295QyUqgshhwgS4xwFOkXzA==
X-Google-Smtp-Source: APXvYqx9TDG0Lr2SN5dRxW/+L8a98eXpzWzxOnFNh71eBbIDihuNaU52qVET1Y7r5ElfIRGM27CypQ==
X-Received: by 2002:a17:902:6907:: with SMTP id j7mr807838plk.88.1582838717243;
        Thu, 27 Feb 2020 13:25:17 -0800 (PST)
Received: from google.com ([2620:15c:201:0:7f8c:9d6e:20b8:e324])
        by smtp.gmail.com with ESMTPSA id k9sm8493396pfh.153.2020.02.27.13.25.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 13:25:16 -0800 (PST)
Date:   Thu, 27 Feb 2020 13:25:12 -0800
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v7 1/9] block: Keyslot Manager for Inline Encryption
Message-ID: <20200227212512.GA162309@google.com>
References: <20200221115050.238976-1-satyat@google.com>
 <20200221115050.238976-2-satyat@google.com>
 <20200221170434.GA438@infradead.org>
 <20200221173118.GA30670@infradead.org>
 <20200227181411.GB877@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227181411.GB877@sol.localdomain>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Feb 27, 2020 at 10:14:11AM -0800, Eric Biggers wrote:
> On Fri, Feb 21, 2020 at 09:31:18AM -0800, Christoph Hellwig wrote:
> > On Fri, Feb 21, 2020 at 09:04:34AM -0800, Christoph Hellwig wrote:
> > > Given that blk_ksm_get_slot_for_key returns a signed keyslot that
> > > can return errors, and the only callers stores it in a signed variable
> > > I think this function should take a signed slot as well, and the check
> > > for a non-negative slot should be moved here from the only caller.
> > 
> > Actually looking over the code again I think it might be better to
> > return only the error code (and that might actually be a blk_status_t),
> > and then use an argument to return a pointer to the actual struct
> > keyslot.  That gives us much easier to understand code and better
> > type safety.
> 
> That doesn't make sense because the caller only cares about the keyslot number,
> not the 'struct keyslot'.  The 'struct keyslot' is internal to
> keyslot-manager.c, as it only contains keyslot management information.
> 
I think it does make some sense at least to make the keyslot type opaque
to most of the system other than the driver itself (the driver will now
have to call a function like blk_ksm_slot_idx_for_keyslot to actually get
a keyslot number at the end of the day). Also this way, the keyslot manager
can verify that the keyslot passed to blk_ksm_put_slot is actually part of
that keyslot manager (and that somebody isn't releasing a slot number that
was actually acquired from a different keyslot manager). I don't think
it's much benefit or loss either way, but I already switched to passing
pointers to struct keyslot around instead of ints, so I'll keep it that
way unless you strongly feel that using ints in this case is better
than struct keyslot *.
> Your earlier suggestion of making blk_ksm_put_slot() be a no-op on a negative
> keyslot number sounds fine though.
> 
> - Eric
