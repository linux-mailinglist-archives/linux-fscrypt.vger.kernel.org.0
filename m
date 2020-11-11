Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7DE2AEE0A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Nov 2020 10:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgKKJpt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Nov 2020 04:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKKJps (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Nov 2020 04:45:48 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5763C0613D4
        for <linux-fscrypt@vger.kernel.org>; Wed, 11 Nov 2020 01:45:46 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id f18so1103204pgi.8
        for <linux-fscrypt@vger.kernel.org>; Wed, 11 Nov 2020 01:45:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NjIaSEpNiDwwZKuhwZzNWaj2OCWVwqB2zttEUEyFMg4=;
        b=PbeCk8mqq8R8ljKQvWxM7EIloYHLl5nWuSSVBMkChHK8UZ/dYUhcl4uEwMj0sCTWCb
         sNE+qFbF8+SDFGf4ITm2CZR6uO3iDUWvIdRqc3IqORmlIGvKUeGaZKfOe50pFP9mCdFF
         1yCdD/LZGZZFjJdmYDWS304hLkQOtv9vqqLlb/QQ1a9JvXbOT84XTXLC0ASj6BeGAOR/
         ZMWQSVKTikbqkp7m86Cc8r1+Fgm69Uld0shQt+gGUoPUccG0aYWDZRQE4x+OiHeheOBr
         BwzTHifFLCLVtCYVUwD0tphfA877lEFFFJigzdvgeIa9+LMY8/MBVz4x2X9H6YAN7zof
         8knQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NjIaSEpNiDwwZKuhwZzNWaj2OCWVwqB2zttEUEyFMg4=;
        b=PLZ/3D5xTiy56eBbxlJ9t0jfY/f806uOiYIy+4Or/t2twcxHWKn/E0jGgujTi30aC5
         qKAcGlkJx+bh9TTl3s4bqDxXRhFZnrL10CZd2+U05KOZTkfx64GCo6w14Y4GWyGaSptN
         zzvd4TkX8dvn2BgGEkgsdjoRhzO3868ELKX1Zee5Y4j9eZXN1EvSBLdZKQodnTnGCH5g
         lHhO7i6CqRGazZ74q8A7F5S8B0gjTZiZUwCiXT2jG/0GF52p2SqFEAGxFuKYPVRMA+6W
         svtZRACagXU/HfbqDRMkXQ1y9ZJZRe4cjgB3ewPajfX0HLEEY4QrrE+ic5EYP9B5R/qO
         KyxQ==
X-Gm-Message-State: AOAM530J8gazbkP/Bcsq14Iq+V9ZkNquv73DfkzmsU+9fJK4nIE8mPvt
        rCPgHlDEZplVzNlrokwRT9+obg==
X-Google-Smtp-Source: ABdhPJzOs8jWe2qmtkaRDl7WfnnhESKVM/Z0So0cZqFQAgHlv7Qy4t6FEcquMk9j87wMLW2VMu4xFg==
X-Received: by 2002:a63:574a:: with SMTP id h10mr21109186pgm.209.1605087946206;
        Wed, 11 Nov 2020 01:45:46 -0800 (PST)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id t74sm1891822pfc.47.2020.11.11.01.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 01:45:45 -0800 (PST)
Date:   Wed, 11 Nov 2020 09:45:38 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] block/keyslot-manager: prevent crash when num_slots=1
Message-ID: <20201111094538.GA3907007@google.com>
References: <20201111021427.466349-1-ebiggers@kernel.org>
 <20201111092305.GA13004@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111092305.GA13004@infradead.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 11, 2020 at 09:23:05AM +0000, Christoph Hellwig wrote:
> On Tue, Nov 10, 2020 at 06:14:27PM -0800, Eric Biggers wrote:
> > +	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
> > +	 * buckets.  This only makes a difference when there is only 1 keyslot.
> > +	 */
> > +	slot_hashtable_size = max(slot_hashtable_size, 2U);
> 
> shouldn't this be a min()?
I think it should be max(), since we want whichever is larger between 2
and the original slot_hashtable_size :)
