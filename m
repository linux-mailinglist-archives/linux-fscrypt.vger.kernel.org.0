Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443E6140F29
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Jan 2020 17:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgAQQlg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 17 Jan 2020 11:41:36 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39661 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726603AbgAQQlf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 17 Jan 2020 11:41:35 -0500
Received: from callcc.thunk.org (guestnat-104-133-0-111.corp.google.com [104.133.0.111] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 00HGesH5016861
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Jan 2020 11:40:56 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 44E2E4207DF; Fri, 17 Jan 2020 11:40:54 -0500 (EST)
Date:   Fri, 17 Jan 2020 11:40:54 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH] fscrypt: reserve flags for hardware-wrapped keys feature
Message-ID: <20200117164054.GD448999@mit.edu>
References: <20200116192008.35766-1-ebiggers@kernel.org>
 <20200117081246.GA16846@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117081246.GA16846@infradead.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jan 17, 2020 at 12:12:46AM -0800, Christoph Hellwig wrote:
> On Thu, Jan 16, 2020 at 11:20:08AM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Reserve flags for the hardware-wrapped keys feature which is being
> > worked on [1].  FSCRYPT_POLICY_FLAG_HW_WRAPPED_KEY will denote that the
> > encryption policy needs a hardware-wrapped key to be unlocked.
> > FSCRYPT_ADD_KEY_FLAG_HW_WRAPPED will denote that the key being added is
> > a hardware-wrapped key.
> > 
> > This reservation is tentative, and these codepoints may be reused if the
> > feature is not upstreamed.
> 
> NAK.  While the feature itself sounds really useful we don't just
> reserve format bits for code not upstream.

I disagree; saving a codepoint to avoid accidental collision of a
feature bit is a good and proper thing to do.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>

							- Ted

