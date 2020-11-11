Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170AA2AF8FF
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Nov 2020 20:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgKKTZm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Nov 2020 14:25:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725955AbgKKTZm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Nov 2020 14:25:42 -0500
Received: from gmail.com (unknown [104.132.1.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37AF220829;
        Wed, 11 Nov 2020 19:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605122741;
        bh=WttcdYX9+Ptt1FQNSfDcXZ0ZpEP+FSXhqqP2aTUE60E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2Oy6uT7odgKmZjetnE+G2b97ok076+5svemmMnynt2TnbPwtBxbO35w1Iu0MsoWZk
         1A7rzS2AxHVtHEzFLPIPf3N31PqmwZz7010R38+abLng+vOnBoQceydGpuny9GsoWl
         RA7rPddhlFEUJDY+dmdouADpuWINQUupb3jP3Av8=
Date:   Wed, 11 Nov 2020 11:25:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] block/keyslot-manager: prevent crash when num_slots=1
Message-ID: <20201111192539.GB335825@gmail.com>
References: <20201111021427.466349-1-ebiggers@kernel.org>
 <20201111092305.GA13004@infradead.org>
 <20201111094538.GA3907007@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111094538.GA3907007@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 11, 2020 at 09:45:38AM +0000, Satya Tangirala wrote:
> On Wed, Nov 11, 2020 at 09:23:05AM +0000, Christoph Hellwig wrote:
> > On Tue, Nov 10, 2020 at 06:14:27PM -0800, Eric Biggers wrote:
> > > +	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
> > > +	 * buckets.  This only makes a difference when there is only 1 keyslot.
> > > +	 */
> > > +	slot_hashtable_size = max(slot_hashtable_size, 2U);
> > 
> > shouldn't this be a min()?
> I think it should be max(), since we want whichever is larger between 2
> and the original slot_hashtable_size :)

max() is correct.  I could just open-code it, if that would make it clearer:

	/*
	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
	 * buckets.  This only makes a difference when there is only 1 keyslot.
	 */
	if (slot_hashtable_size < 2)
		slot_hashtable_size = 2;
