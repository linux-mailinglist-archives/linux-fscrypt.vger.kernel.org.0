Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C631BB3BE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 28 Apr 2020 04:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgD1COr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 27 Apr 2020 22:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726272AbgD1COr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 27 Apr 2020 22:14:47 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6211FC03C1A8
        for <linux-fscrypt@vger.kernel.org>; Mon, 27 Apr 2020 19:14:47 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id c21so6913747plz.4
        for <linux-fscrypt@vger.kernel.org>; Mon, 27 Apr 2020 19:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dNDHgCC2Tbezyzaz1jik79FYVEDQH+X+/Zl/FX9zdvE=;
        b=KnwnZ++vm3JMJEkBfjFTzuMZedHlKQkCikCMg8o+5SWaFUknNqNFJgJ3P2p9Bu58HM
         uf017eQcybmhKeNlI5fCSw+3L8DgrWC0bVbQgF+oc8afCfYiOFaqp3b/LyOGYDXw57Uj
         QuOKGbFyCv2xwx1rc1Vb7FqncrawNMyBdsB/86iAof/qDTTDi8hg+1WYx/5AFR7ebw4n
         sQ/ZxXJZQZcKzI3CfLRPf/Fz31PKeWGx/2vzUUpwYkPulnIEOq6wrS3fwVu+YWWfJChZ
         N8ChLbccFNspOjuqbjvUfB4gcGKYV27YIq0wzgMlqrHmCRN1evUqwui+9EvxyLrUj/S8
         NQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dNDHgCC2Tbezyzaz1jik79FYVEDQH+X+/Zl/FX9zdvE=;
        b=FUZs5sxqUOSeuCZqDdlKuELhjgDyGzPBd4GQERVQQ3YlbiLOPoYCIyFbz9OtcIxwaf
         fvDnBHvqJEuD18b1T2IicA+YMMT3j7hRrrPohvRUsZIYC4FkydaIPILiEVBaZaVnPkGZ
         09JIShFc4ZVe8uHAZl8ygQy7gDV5NSUZYTqppLCGT8v9pecw4IzwnZMoRymkmAz4JeEp
         cblLMd3L9IO8arVB7SrOBf5yA1DI20X4k8G0Q0hfMUPMGavQuVjnK0ouoFeZWXjfY0s3
         p3eut5iKwJ49SqzfnGSz2h/r/NtFDkOhRlxwzKKTKqeOVCd0KVT/AziWDXwvAbIxSZ+v
         liew==
X-Gm-Message-State: AGi0PuY48SR8hnpzicVrLvMvYsq3z2MpMhpKsAabuLy/fVUK774pq9rG
        6IJhpTCDI0Bcs1qu80SncZ1qkw==
X-Google-Smtp-Source: APiQypJ+Q+7kB5uiF6PP1T5S7xnrAVLUajbrQdNpmN5RmNLCd3B63jV5Haw2iF8Xd19BTMuAfLQl5w==
X-Received: by 2002:a17:90a:68cb:: with SMTP id q11mr2161545pjj.15.1588040086489;
        Mon, 27 Apr 2020 19:14:46 -0700 (PDT)
Received: from google.com (56.4.82.34.bc.googleusercontent.com. [34.82.4.56])
        by smtp.gmail.com with ESMTPSA id q64sm13385299pfc.112.2020.04.27.19.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 19:14:45 -0700 (PDT)
Date:   Tue, 28 Apr 2020 02:14:41 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v10 02/12] block: Keyslot Manager for Inline Encryption
Message-ID: <20200428021441.GA52406@google.com>
References: <20200408035654.247908-1-satyat@google.com>
 <20200408035654.247908-3-satyat@google.com>
 <20200422092250.GA12290@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422092250.GA12290@infradead.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Apr 22, 2020 at 02:22:50AM -0700, Christoph Hellwig wrote:
> > +bool blk_ksm_crypto_cfg_supported(struct blk_keyslot_manager *ksm,
> > +				  const struct blk_crypto_config *cfg)
> > +{
> > +	if (!ksm)
> > +		return false;
> > +	return (ksm->crypto_modes_supported[cfg->crypto_mode] &
> > +		cfg->data_unit_size) &&
> > +	       (ksm->max_dun_bytes_supported >= cfg->dun_bytes);
> 
> Nit: why not expand this a bit to be more readable:
> 
> 	if (!(ksm->crypto_modes_supported[cfg->crypto_mode] &
> 			cfg->data_unit_size))
> 		return false;
> 	if (ksm->max_dun_bytes_supported < cfg->dun_bytes)
> 		return false;
> 	return true;
> 
> > +int blk_ksm_evict_key(struct blk_keyslot_manager *ksm,
> > +		      const struct blk_crypto_key *key)
> > +{
> > +	struct blk_ksm_keyslot *slot;
> > +	int err = 0;
> > +
> > +	blk_ksm_hw_enter(ksm);
> > +	slot = blk_ksm_find_keyslot(ksm, key);
> > +	if (!slot)
> > +		goto out_unlock;
> > +
> > +	if (atomic_read(&slot->slot_refs) != 0) {
> > +		err = -EBUSY;
> > +		goto out_unlock;
> > +	}
> 
> This check looks racy.
Yes, this could in theory race with blk_ksm_put_slot (e.g. if it's
called while there's still IO in flight/IO that just finished) - But
it's currently only called by fscrypt when a key is being destroyed,
which only happens after all the inodes using that key are evicted, and
no data is in flight, so when this function is called, slot->slot_refs
will be 0. In particular, this function should only be called when the
key isn't being used for IO anymore. I'll add a WARN_ON_ONCE and also
make the assumption clearer. We could also instead make this wait for
the slot_refs to become 0 and then evict the key instead of just
returning -EBUSY as it does now, but I'm not sure if it's really what
we want to do/worth doing right now...
