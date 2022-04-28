Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6F6E51294F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Apr 2022 04:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbiD1CH0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Apr 2022 22:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiD1CHZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Apr 2022 22:07:25 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A4298F6C;
        Wed, 27 Apr 2022 19:04:12 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23S0frbN028127;
        Thu, 28 Apr 2022 02:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=CuPlyKAxT2uex1+xJwaBMsG/ehh6GyV6KiEz5N16G6s=;
 b=H7AJmCX+oSFuqawBkKJDCJKql3Mgdm42+ZpM0v2l14wAKunSwFUaKgofrFP7VLkWTzc9
 Ukua+f1uoa+TcLhDQrYGdUefEmz404cnKkQ+B2Z1tuMlfCgOAvCff9p4ktwZSR+ZHxsv
 8RsRHjsbqYQaPB3URdh88tGkKZlk6jZSo6zZDUDXCmlPndq9vPd96Lrk9wyDEOCyiHj8
 iF3LrjOzfMMXgkYGV4+WQWrk8dOiacZDwGUDXwxPfBBMpucfV/ULyL49yuuXuAxODTfj
 dqcjF1q0Uk71qQuKSLFz7I95skNtIGAETZgWxPFkjCHpMCO4OLROhgJSzPS5xA5bBV67 Tw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fqgkw93u6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 02:04:04 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23S23gpM024856;
        Thu, 28 Apr 2022 02:04:02 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06fra.de.ibm.com with ESMTP id 3fm8qhnack-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 02:04:02 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23S1oseh48234782
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 01:50:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A787AA4054;
        Thu, 28 Apr 2022 02:03:59 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECB8AA405C;
        Thu, 28 Apr 2022 02:03:58 +0000 (GMT)
Received: from sig-9-65-70-226.ibm.com (unknown [9.65.70.226])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Apr 2022 02:03:58 +0000 (GMT)
Message-ID: <4e9eecd01d1cb51dd3e8e92783742df0b66921ab.camel@linux.ibm.com>
Subject: Re: [PATCH v7 3/5] ima: permit fsverity's file digests in the IMA
 measurement list
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 27 Apr 2022 22:03:58 -0400
In-Reply-To: <YkyYUzEK9Tw4TgL2@gmail.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
         <20220325223824.310119-4-zohar@linux.ibm.com> <YkyYUzEK9Tw4TgL2@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _qcFZ9wAE2VmYHHq0SWIehbeUnXWaPaa
X-Proofpoint-ORIG-GUID: _qcFZ9wAE2VmYHHq0SWIehbeUnXWaPaa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_04,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 clxscore=1015 mlxlogscore=999 malwarescore=0 adultscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280010
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 2022-04-05 at 19:28 +0000, Eric Biggers wrote:
> On Fri, Mar 25, 2022 at 06:38:22PM -0400, Mimi Zohar wrote:
> > Permit fsverity's file digest (a hash of struct fsverity_digest) to be
> > included in the IMA measurement list, based on the new measurement
> > policy rule 'digest_type=verity' option.
> 
> "fsverity's file digest" *is* 'struct fsverity_digest', not a hash of it.
> Did you mean to write 'struct fsverity_descriptor'?

Fixed.

> 
> > diff --git a/Documentation/security/IMA-templates.rst b/Documentation/security/IMA-templates.rst
> > index 1a91d92950a7..2d4789dc7750 100644
> > --- a/Documentation/security/IMA-templates.rst
> > +++ b/Documentation/security/IMA-templates.rst
> > @@ -68,6 +68,9 @@ descriptors by adding their identifier to the format string
> >   - 'd-ng': the digest of the event, calculated with an arbitrary hash
> >     algorithm (field format: [<hash algo>:]digest, where the digest
> >     prefix is shown only if the hash algorithm is not SHA1 or MD5);
> > + - 'd-ngv2': same as d-ng, but prefixed with the digest type.
> > +    field format: [<digest type>:<hash algo>:]digest,
> > +        where the digest type is either "ima" or "verity".
> 
> As in patch 2, it is not clear what the square brackets mean here.  Maybe they
> mean that "<digest type>:<hash algo>:" is optional, but it is not explained when
> they will be present and when they will not be present.

Agreed, removed.

> 
> >   - 'd-modsig': the digest of the event without the appended modsig;
> >   - 'n-ng': the name of the event, without size limitations;
> >   - 'sig': the file signature, or the EVM portable signature if the file
> > @@ -106,3 +109,8 @@ currently the following methods are supported:
> >     the ``ima_template=`` parameter;
> >   - register a new template descriptor with custom format through the kernel
> >     command line parameter ``ima_template_fmt=``.
> > +
> > +
> > +References
> > +==========
> > +[1] Documentation/filesystems/fsverity.rst
> 
> Is this meant to be a footnote?  There are no references to it above.
> 
> > @@ -242,14 +267,29 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
> >  	 */
> >  	i_version = inode_query_iversion(inode);
> >  	hash.hdr.algo = algo;
> > +	hash.hdr.length = hash_digest_size[algo];
> >  
> >  	/* Initialize hash digest to 0's in case of failure */
> >  	memset(&hash.digest, 0, sizeof(hash.digest));
> >  
> > -	if (buf)
> > +	if (buf) {
> >  		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
> > -	else
> > +	} else if (iint->flags & IMA_VERITY_REQUIRED) {
> > +		result = ima_get_verity_digest(iint, &hash);
> > +		switch (result) {
> > +		case 0:
> > +			break;
> > +		case -ENODATA:
> > +			audit_cause = "no-verity-digest";
> > +			result = -EINVAL;
> > +			break;
> > +		default:
> > +			audit_cause = "invalid-verity-digest";
> > +			break;
> > +		}
> > +	} else {
> >  		result = ima_calc_file_hash(file, &hash.hdr);
> > +	}
> >  
> >  	if (result && result != -EBADF && result != -EINVAL)
> >  		goto out;
> 
> The above code only calls ima_get_verity_digest() if 'buf' is non-NULL,
> otherwise it calls ima_calc_buffer_hash().  Under what circumstances is 'buf'
> non-NULL?  Does this imply that 'digest_type=verity' does not always use verity
> digests, and if not, when are they used and when are they not used?

Agreed, it should always be based on policy.

FYI, instead of IMA pre-reading and calculating the file hash, there
are instances where the kernel reads the entire file into memory.   For
example, kernel_read_file() calls security_kernel_post_read_file(),
which calls ima_post_read_file().

> 
> > +/*
> > + * Make sure the policy rule and template format are in sync.
> > + */
> > +static void check_template_field(const struct ima_template_desc *template,
> > +				 const char *field, const char *msg)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < template->num_fields; i++)
> > +		if (!strcmp(template->fields[i]->field_id, field))
> > +			return;
> > +
> > +	pr_notice_once("%s", msg);
> > +}
> 
> A better description for this function would be something like "Warn if the
> template does not contain the given field."

Ok
> 
> > index daf49894fd7d..d42a01903f08 100644
> > --- a/security/integrity/integrity.h
> > +++ b/security/integrity/integrity.h
> > @@ -32,7 +32,7 @@
> >  #define IMA_HASHED		0x00000200
> >  
> >  /* iint policy rule cache flags */
> > -#define IMA_NONACTION_FLAGS	0xff000000
> > +#define IMA_NONACTION_FLAGS	0xff800000
> >  #define IMA_DIGSIG_REQUIRED	0x01000000
> >  #define IMA_PERMIT_DIRECTIO	0x02000000
> >  #define IMA_NEW_FILE		0x04000000
> > @@ -40,6 +40,7 @@
> >  #define IMA_FAIL_UNVERIFIABLE_SIGS	0x10000000
> >  #define IMA_MODSIG_ALLOWED	0x20000000
> >  #define IMA_CHECK_BLACKLIST	0x40000000
> > +#define IMA_VERITY_REQUIRED	0x80000000
> 
> It is intentional that the new bit added to IMA_NONACTION_FLAGS is not the same
> as IMA_VERITY_REQUIRED?

Thanks for catching this.  Previous versions required an additional
bit, but that isn't the case now.

thanks,

Mimi

