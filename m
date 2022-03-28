Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820704E98B9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Mar 2022 15:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243494AbiC1NxB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Mar 2022 09:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243495AbiC1NxA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Mar 2022 09:53:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD855EBEB;
        Mon, 28 Mar 2022 06:51:18 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22SDIID9013485;
        Mon, 28 Mar 2022 13:51:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=pr6D/jbd4lK0qyeCKzWTrtA5NkWr9yYSeGF6wt9w0lg=;
 b=nwI9w/Ew6yo8vLrscTHGMKI9xfdxGTFFWQoBmQocesNdw2JEw9ssABQg+O1xVqDaNbYy
 p2v3G4jd5f/aLQBV49tN+0UPTehXrebc3GFBeTaVWejzS03GPFPjXubqicuJ3h4Q70KL
 yYlv+vAYikdmImV9enkOuW9qG29h0spLp7PNsC5077j8TeuF0qkR54izO/6BBttTUZvp
 FReUDLmuNvl0pPpdU21eDp8UJCI/GnzzBvE9uCeNF+xh2fyRwgpFMFUSCWpZaO8pT4Z/
 LQlkyy1O5TTcDVtvHEghUPXJQlA/09Kfrdv7eu4ozHb9Tv240QSK5f4hgtwp9/N4rLox ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3dsngn76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 13:51:08 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22SDg5wt019333;
        Mon, 28 Mar 2022 13:51:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f3dsngn6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 13:51:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22SDhaa7013419;
        Mon, 28 Mar 2022 13:51:06 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3f1tf8v3hc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 13:51:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22SDp3Bl34210212
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 13:51:03 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D7634203F;
        Mon, 28 Mar 2022 13:51:03 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 731E042045;
        Mon, 28 Mar 2022 13:51:02 +0000 (GMT)
Received: from sig-9-65-77-40.ibm.com (unknown [9.65.77.40])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Mar 2022 13:51:02 +0000 (GMT)
Message-ID: <152f1bfa9a07354183ca808a036d5e3fef664ea8.camel@linux.ibm.com>
Subject: Re: [PATCH v7 1/5] fs-verity: define a function to return the
 integrity protected file digest
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     "Guozihua (Scott)" <guozihua@huawei.com>,
        linux-integrity@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
Date:   Mon, 28 Mar 2022 09:51:01 -0400
In-Reply-To: <0e803aad-5ae6-349b-b17e-89a832306925@huawei.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
         <20220325223824.310119-2-zohar@linux.ibm.com>
         <0e803aad-5ae6-349b-b17e-89a832306925@huawei.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: WC8DueF78B8C15jgMAIQ6z0M7HltKIvp
X-Proofpoint-ORIG-GUID: TsjQreu5Rozw_elGqqFo-o0zcO1GdIi9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_05,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 malwarescore=0 adultscore=0 clxscore=1015 suspectscore=0
 impostorscore=0 mlxscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Scott,

On Mon, 2022-03-28 at 11:45 +0800, Guozihua (Scott) wrote:
> > +
> > +/**
> > + * fsverity_get_digest() - get a verity file's digest
> > + * @inode: inode to get digest of
> > + * @digest: (out) pointer to the digest
> > + * @alg: (out) pointer to the hash algorithm enumeration
> > + *
> > + * Return the file hash algorithm and digest of an fsverity protected file.
> > + * Assumption: before calling fsverity_get_digest(), the file must have been
> > + * opened.
> > + *
> > + * Return: 0 on success, -errno on failure
> > + */
> > +int fsverity_get_digest(struct inode *inode,
> > +                     u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
> > +                     enum hash_algo *alg)
> > +{
> > +     const struct fsverity_info *vi;
> > +     const struct fsverity_hash_alg *hash_alg;
> > +     int i;
> > +
> > +     vi = fsverity_get_info(inode);
> > +     if (!vi)
> > +             return -ENODATA; /* not a verity file */
> > +
> > +     hash_alg = vi->tree_params.hash_alg;
> > +     memset(digest, 0, FS_VERITY_MAX_DIGEST_SIZE);
> 
> Hi Mimi,
> 
> I would suggest moving this memset downward right before the memcpy.

By doing it here, any existing garbage stored in the digest is cleared
before returning a failure.

thanks,

Mimi
> 
> > +
> > +     /* convert the verity hash algorithm name to a hash_algo_name enum */
> > +     i = match_string(hash_algo_name, HASH_ALGO__LAST, hash_alg->name);
> > +     if (i < 0)
> > +             return -EINVAL;
> > +     *alg = i;
> > +
> > +     if (WARN_ON_ONCE(hash_alg->digest_size != hash_digest_size[*alg]))
> > +             return -EINVAL;
> > +     memcpy(digest, vi->file_digest, hash_alg->digest_size);
> > +
> > +     pr_debug("file digest %s:%*phN\n", hash_algo_name[*alg],
> > +              hash_digest_size[*alg], digest);
> > +
> > +     return 0;


