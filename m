Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B72C263A263
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Nov 2022 08:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbiK1H7w (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 02:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiK1H7v (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 02:59:51 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B2F64E9;
        Sun, 27 Nov 2022 23:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3Gs3PsmZkhDAzjVqppYL2tAQScK434JhB2ghF4jK5i0=; b=RmBMn98/uMdV2WyumP8p/2uRXw
        GDVnOelK//TT9h6VYONjr+EyXDH85AMma9OxGuAsqMWW2lOrw0cH6Il14Q6Gj4ECBxEEGWiB7DdfC
        qPZVJ8j9xzTR3h2tIJtAUzatG8Gn5DJElr275FyIK/drQjRxg5P38/9CipKShd/GWoRdLPlXJOkTo
        dOCYwV86CW7b8Gp9fR3Ox4TP0vR36LO8+RowNlq03xhk9RZUfbbirx+1ORfGR6AeAIhJZ20+L5eaO
        yKAK+WRgBVtq5lQZsBwabCGORqwDzD0mqOUwQ0YHldWqguwUjUAEr7O008sRyJ3ClLph8brhr7vm9
        RS2/GjYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ozZ3E-00HX0W-32; Mon, 28 Nov 2022 07:59:40 +0000
Date:   Sun, 27 Nov 2022 23:59:40 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH v5 00/18] btrfs: add fscrypt integration
Message-ID: <Y4RqbKSdxQ5owg0h@infradead.org>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
 <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
 <81e3763c-2c02-2c9f-aece-32aa575abbca@dorminy.me>
 <55686ed2-b182-3478-37aa-237e306be6e1@dorminy.me>
 <4857f0df-dae0-178e-85e3-307197701d34@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4857f0df-dae0-178e-85e3-307197701d34@dorminy.me>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 23, 2022 at 08:22:30PM -0500, Sweet Tea Dorminy wrote:
> The document has been updated to hopefully reflect the discussion we had;
> further comments are always appreciated. https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing

How is this going to work with hardware encryption offload?  I think
the number of keys for UFS and eMMC inline encryption, but Eric may
correct me.
